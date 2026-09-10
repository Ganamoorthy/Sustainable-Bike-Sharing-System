#include "network_module.h"

#include "config.h"
#include "shared_state.h"

#include <Arduino.h>
#include <Preferences.h>
#include <esp_task_wdt.h>
#include <stdlib.h>
#include <string.h>

namespace
{
bool sendAT(const String &cmd, const char *expected, uint32_t timeout,
            const char *expected2 = nullptr, String *rawOut = nullptr)
{
  while (simSerial.available())
    simSerial.read();

  Serial.print("[TX] ");
  Serial.println(cmd);
  simSerial.print(cmd);
  simSerial.print("\r\n");

  String res;
  uint32_t start = millis();
  while (millis() - start < timeout)
  {
    esp_task_wdt_reset();
    while (simSerial.available())
    {
      char c = simSerial.read();
      res += c;
      if (res.indexOf(expected) != -1)
      {
        if (rawOut)
          *rawOut = res;
        return true;
      }
      if (expected2 && res.indexOf(expected2) != -1)
      {
        if (rawOut)
          *rawOut = res;
        return true;
      }
      if (res.indexOf("ERROR") != -1 || res.indexOf("CLOSED") != -1)
      {
        if (rawOut)
          *rawOut = res;
        return false;
      }
    }
  }

  if (rawOut)
    *rawOut = res;
  return false;
}

bool connectMQTT()
{
  Serial.println("[NET] Connecting...");

  sendAT("AT+MIPCLOSE", "OK", 2000);
  sendAT("AT+MDISC", "OK", 2000);
  delay(1000);

  if (!sendAT("AT", "OK", 1000))
    return false;
  if (!sendAT("AT+CPIN?", "READY", 3000))
    return false;
  sendAT("AT+CSQ", "OK", 2000);

  String cgdcont = "AT+CGDCONT=1,\"IP\",\"";
  cgdcont += APN;
  cgdcont += "\"";
  if (!sendAT(cgdcont, "OK", 3000))
    return false;
  if (!sendAT("AT+CGATT=1", "OK", 5000))
    return false;

  String cfg = "AT+MCONFIG=\"";
  cfg += CLIENT_ID;
  cfg += "\",\"";
  cfg += MQTT_USER;
  cfg += "\",\"";
  cfg += MQTT_PASS;
  cfg += "\"";
  if (!sendAT(cfg, "OK", 3000))
    return false;

  String ip = "AT+MIPSTART=\"";
  ip += BROKER;
  ip += "\",";
  ip += PORT;
  if (!sendAT(ip, "CONNECT OK", 15000, "ALREADY CONNECT"))
    return false;
  if (!sendAT("AT+MCONNECT=1,60", "CONNACK OK", 15000))
    return false;

  Serial.println("[NET] MQTT connected");
  return true;
}

void softResetModem()
{
  Serial.println("[NET] Modem soft-reset: AT+CFUN=1,1");
  sendAT("AT+CFUN=1,1", "OK", 5000);
  delay(8000);
  while (simSerial.available())
    simSerial.read();
}

bool publishToTopic(const char *topic, const char *payload)
{
  String cmd = "AT+MPUB=\"";
  cmd += topic;
  cmd += "\",0,0,\"";
  cmd += payload;
  cmd += "\"";
  bool ok = sendAT(cmd, "OK", 5000);
  Serial.printf(ok ? "[PUB OK] %s\n" : "[PUB FAIL] %s\n", topic);
  return ok;
}

int appendChecksum(char *buf, size_t bufSize, int len)
{
  if (len < 0)
    return 0;
  if ((size_t)len >= bufSize)
    len = (int)bufSize - 1;

  uint8_t chk = 0;
  for (int i = 0; i < len; i++)
    chk ^= (uint8_t)buf[i];

  int remaining = (int)bufSize - len;
  int written = snprintf(buf + len, remaining, ",chk=%02X", chk);
  if (written < 0)
    return len;
  if (written >= remaining)
    return (int)bufSize - 1;
  return len + written;
}

void mncToText(const CellSnapshot &c, char *out, size_t outSize)
{
  if (c.mncDigits == 3)
    snprintf(out, outSize, "%03d", c.mnc);
  else if (c.mncDigits == 2)
    snprintf(out, outSize, "%02d", c.mnc);
  else
    snprintf(out, outSize, "%d", c.mnc);
}

int buildLivePayload(char *buf, size_t bufSize, const GpsSnapshot &g,
                     const ImuSnapshot &im, const BatterySnapshot &b,
                     const CellSnapshot &c, uint32_t seq, bool crash)
{
  char mncText[8];
  mncToText(c, mncText, sizeof(mncText));
  char src = g.fixValid ? 'G' : 'C';

  int n = snprintf(
      buf, bufSize,
      "id=%s,fw=%s,ts=%02u%02u%02u,lat=%.4f,lon=%.4f,fix=%d,sat=%lu,alt=%.1f,"
      "v1=%.2f,v2=%.2f,v3=%.2f,tot=%.2f,imb=%.2f,"
      "ax=%.2f,ay=%.2f,az=%.2f,gx=%.1f,gy=%.1f,gz=%.1f,mx=%.1f,my=%.1f,mz=%.1f,"
      "tmp=%.1f,crash=%d,src=%c,mcc=%d,mnc=%s,lac=%ld,cid=%ld,rssi=%d,csq=%d,"
      "reg=%u,seq=%lu",
      DEVICE_ID, FW_VERSION, g.hh, g.mm, g.ss, g.lat, g.lon,
      g.fixValid ? 1 : 0, (unsigned long)g.sats, g.alt, b.cell1, b.cell2,
      b.cell3, b.total, b.imbalance, im.ax, im.ay, im.az, im.gx, im.gy, im.gz,
      im.mx, im.my, im.mz, im.tempC, crash ? 1 : 0, src, c.mcc, mncText, c.lac,
      c.cellId, c.rssiDbm, c.csqRaw, (unsigned)c.regStatus, (unsigned long)seq);

  return appendChecksum(buf, bufSize, n);
}

int buildImuPayload(char *buf, size_t bufSize, const ImuSnapshot &im,
                    uint32_t tsMs, uint32_t seq)
{
  int n =
      snprintf(buf, bufSize,
               "id=%s,ts=%lu,ax=%.3f,ay=%.3f,az=%.3f,gx=%.3f,gy=%.3f,gz=%.3f,"
               "mx=%.3f,my=%.3f,mz=%.3f,tmp=%.2f,seq=%lu",
               DEVICE_ID, (unsigned long)tsMs, im.ax, im.ay, im.az, im.gx,
               im.gy, im.gz, im.mx, im.my, im.mz, im.tempC,
               (unsigned long)seq);

  return appendChecksum(buf, bufSize, n);
}

int buildGpsPayload(char *buf, size_t bufSize, const GpsSnapshot &g,
                    uint32_t tsMs, uint32_t seq)
{
  int n = snprintf(buf, bufSize,
                   "id=%s,ts=%lu,lat=%.7f,lon=%.7f,fix=%d,hdop=%.2f,sat=%lu,"
                   "alt=%.2f,spd=%.2f,seq=%lu",
                   DEVICE_ID, (unsigned long)tsMs, g.lat, g.lon,
                   g.fixValid ? 1 : 0, g.hdop, (unsigned long)g.sats, g.alt,
                   g.speedKmh, (unsigned long)seq);

  return appendChecksum(buf, bufSize, n);
}

int buildCellPayload(char *buf, size_t bufSize, const CellSnapshot &c,
                     uint32_t tsMs, uint32_t seq)
{
  char mncText[8];
  mncToText(c, mncText, sizeof(mncText));

  int n = snprintf(buf, bufSize,
                   "id=%s,ts=%lu,valid=%d,mcc=%d,mnc=%s,lac=%ld,cid=%ld,"
                   "rssi=%d,csq=%d,reg=%u,seq=%lu",
                   DEVICE_ID, (unsigned long)tsMs, c.valid ? 1 : 0, c.mcc,
                   mncText, c.lac, c.cellId, c.rssiDbm, c.csqRaw,
                   (unsigned)c.regStatus, (unsigned long)seq);

  return appendChecksum(buf, bufSize, n);
}

int csqToDbm(int csq)
{
  if (csq < 0 || csq > 31 || csq == 99)
    return 0;
  return -113 + (csq * 2);
}

bool parseCreg(const String &raw, uint8_t &statOut, long &lacOut,
               long &cellIdOut)
{
  int idx = raw.indexOf("+CEREG:");
  int tagLen = 7;
  if (idx == -1)
  {
    idx = raw.indexOf("+CGREG:");
    tagLen = 7;
  }
  if (idx == -1)
  {
    idx = raw.indexOf("+CREG:");
    tagLen = 6;
  }
  if (idx == -1)
    return false;

  int lineEnd = raw.indexOf('\n', idx);
  if (lineEnd == -1)
    lineEnd = raw.length();

  String line = raw.substring(idx + tagLen, lineEnd);
  line.trim();

  const char *p = line.c_str();
  char *endptr = nullptr;
  (void)strtol(p, &endptr, 10);
  if (endptr == p)
    return false;
  p = endptr;

  if (*p == ',')
    p++;
  long stat = strtol(p, &endptr, 10);
  if (endptr == p)
    return false;
  statOut = (uint8_t)stat;

  int q1 = line.indexOf('"');
  if (q1 != -1)
  {
    int q2 = line.indexOf('"', q1 + 1);
    if (q2 != -1)
    {
      String lacHex = line.substring(q1 + 1, q2);
      if (lacHex.length() > 0)
        lacOut = strtol(lacHex.c_str(), nullptr, 16);

      int q3 = line.indexOf('"', q2 + 1);
      if (q3 != -1)
      {
        int q4 = line.indexOf('"', q3 + 1);
        if (q4 != -1)
        {
          String cidHex = line.substring(q3 + 1, q4);
          if (cidHex.length() > 0)
            cellIdOut = strtol(cidHex.c_str(), nullptr, 16);
        }
      }
    }
  }

  return true;
}

bool queryCellInfo(CellSnapshot &out)
{
  CellSnapshot updated = out;
  bool gotAnything = false;

  sendAT("AT+CEREG=2", "OK", 1500);
  sendAT("AT+CGREG=2", "OK", 1500);
  sendAT("AT+CREG=2", "OK", 1500);

  String regRaw;
  uint8_t reg = updated.regStatus;
  long lac = updated.lac;
  long cid = updated.cellId;
  bool parsedReg = false;

  if (sendAT("AT+CEREG?", "OK", 3000, nullptr, &regRaw))
    parsedReg = parseCreg(regRaw, reg, lac, cid);
  if (!parsedReg && sendAT("AT+CGREG?", "OK", 3000, nullptr, &regRaw))
    parsedReg = parseCreg(regRaw, reg, lac, cid);
  if (!parsedReg && sendAT("AT+CREG?", "OK", 3000, nullptr, &regRaw))
    parsedReg = parseCreg(regRaw, reg, lac, cid);

  if (parsedReg)
  {
    updated.regStatus = reg;
    updated.lac = lac;
    updated.cellId = cid;
    gotAnything = true;
  }

  String csqRaw;
  if (sendAT("AT+CSQ", "OK", 2000, nullptr, &csqRaw))
  {
    int idx = csqRaw.indexOf("+CSQ:");
    if (idx != -1)
    {
      int csq = csqRaw.substring(idx + 5).toInt();
      updated.csqRaw = csq;
      updated.rssiDbm = csqToDbm(csq);
      gotAnything = true;
    }
  }

  sendAT("AT+COPS=3,2", "OK", 2000);
  String copsRaw;
  if (sendAT("AT+COPS?", "OK", 3000, nullptr, &copsRaw))
  {
    int q1 = copsRaw.indexOf('"');
    if (q1 != -1)
    {
      int q2 = copsRaw.indexOf('"', q1 + 1);
      if (q2 != -1)
      {
        String numeric = copsRaw.substring(q1 + 1, q2);
        if (numeric.length() >= 5 && numeric.length() <= 6)
        {
          updated.mcc = numeric.substring(0, 3).toInt();
          String mncText = numeric.substring(3);
          updated.mnc = mncText.toInt();
          updated.mncDigits = (uint8_t)mncText.length();
          gotAnything = true;
        }
      }
    }
  }

  updated.valid = gotAnything;
  out = updated;
  return gotAnything;
}

struct TxQueue
{
  struct TxMessage
  {
    char topic[TOPIC_MAX_LEN];
    char payload[PAYLOAD_MAX_LEN];
  };

  TxMessage items[TX_QUEUE_LEN];
  int head = 0;
  int tail = 0;
  int count = 0;

  void push(const char *topic, const char *payload)
  {
    if (count >= TX_QUEUE_LEN)
    {
      head = (head + 1) % TX_QUEUE_LEN;
      count--;
    }

    strncpy(items[tail].topic, topic, TOPIC_MAX_LEN - 1);
    items[tail].topic[TOPIC_MAX_LEN - 1] = 0;
    strncpy(items[tail].payload, payload, PAYLOAD_MAX_LEN - 1);
    items[tail].payload[PAYLOAD_MAX_LEN - 1] = 0;

    tail = (tail + 1) % TX_QUEUE_LEN;
    count++;
  }

  bool pop(TxMessage *out)
  {
    if (count == 0)
      return false;
    *out = items[head];
    head = (head + 1) % TX_QUEUE_LEN;
    count--;
    return true;
  }
};

TxQueue g_txQueue;
} // namespace

void networkTask(void *pv)
{
  (void)pv;
  esp_task_wdt_add(NULL);

  Preferences prefs;
  prefs.begin("bike", false);
  uint32_t seq = prefs.getUInt("seq", 0);

  simSerial.begin(115200, SERIAL_8N1, MODEM_RX, MODEM_TX);

  bool mqttReady = connectMQTT();
  uint32_t backoff = RECONNECT_BASE_MS;
  uint32_t lastAttempt = millis();
  uint32_t lastLivePub = 0;
  uint32_t lastImuPub = 0;
  uint32_t lastGpsPub = 0;
  uint32_t lastCellQuery = 0;
  uint32_t lastCellPub = 0;
  uint32_t lastSeqSave = 0;
  uint32_t lastSavedSeq = seq;
  int reconnectFailCount = 0;

  for (;;)
  {
    esp_task_wdt_reset();

    if (!mqttReady)
    {
      if (millis() - lastAttempt >= backoff)
      {
        lastAttempt = millis();
        Serial.println("[NET] Reconnect attempt...");
        mqttReady = connectMQTT();
        if (mqttReady)
        {
          backoff = RECONNECT_BASE_MS;
          reconnectFailCount = 0;
          lastCellQuery = 0;
        }
        else
        {
          reconnectFailCount++;
          if (reconnectFailCount >= MAX_CONSEC_MQTT_FAILURES)
          {
            softResetModem();
            reconnectFailCount = 0;
            backoff = RECONNECT_BASE_MS;
          }
          else
          {
            backoff = ((backoff * 2 > RECONNECT_MAX_MS) ? RECONNECT_MAX_MS
                                                         : backoff * 2);
          }
        }
      }
      if (millis() - lastSeqSave > 5000 && seq != lastSavedSeq)
      {
        lastSeqSave = millis();
        prefs.putUInt("seq", seq);
        lastSavedSeq = seq;
      }
      vTaskDelay(pdMS_TO_TICKS(200));
      continue;
    }

    GpsSnapshot gpsS;
    ImuSnapshot imuS;
    BatterySnapshot battS;
    CellSnapshot cellS;
    bool jolt = false;
    if (xSemaphoreTake(g_stateMutex, pdMS_TO_TICKS(50)) == pdTRUE)
    {
      gpsS = g_state.gps;
      imuS = g_state.imu;
      battS = g_state.batt;
      cellS = g_state.cell;
      jolt = g_state.imu.joltDetected;
      g_state.imu.joltDetected = false;
      xSemaphoreGive(g_stateMutex);
    }

    if (millis() - lastCellQuery >= CELL_QUERY_MS)
    {
      lastCellQuery = millis();
      CellSnapshot refreshed = cellS;
      queryCellInfo(refreshed);
      cellS = refreshed;

      if (xSemaphoreTake(g_stateMutex, pdMS_TO_TICKS(50)) == pdTRUE)
      {
        g_state.cell = refreshed;
        xSemaphoreGive(g_stateMutex);
      }

      if (refreshed.valid)
      {
        char mncText[8];
        mncToText(refreshed, mncText, sizeof(mncText));
        Serial.printf("[CELL] mcc=%d mnc=%s lac=%ld cid=%ld rssi=%ddBm\n",
                      refreshed.mcc, mncText, refreshed.lac, refreshed.cellId,
                      refreshed.rssiDbm);
      }
      else
      {
        Serial.println("[CELL] query failed");
      }
    }

    if (jolt)
    {
      char buf[PAYLOAD_MAX_LEN];
      seq++;
      buildLivePayload(buf, sizeof(buf), gpsS, imuS, battS, cellS, seq, true);
      Serial.println("[ALERT] possible jolt/crash event");
      if (!publishToTopic(ALERT_TOPIC, buf))
      {
        g_txQueue.push(ALERT_TOPIC, buf);
        mqttReady = false;
        lastAttempt = millis();
      }
    }

    if (mqttReady && g_txQueue.count > 0)
    {
      TxQueue::TxMessage qmsg;
      int flushed = 0;
      while (flushed < 3 && g_txQueue.pop(&qmsg))
      {
        if (!publishToTopic(qmsg.topic, qmsg.payload))
        {
          g_txQueue.push(qmsg.topic, qmsg.payload);
          mqttReady = false;
          lastAttempt = millis();
          break;
        }
        flushed++;
      }
    }

    if (mqttReady && millis() - lastImuPub >= MQTT_IMU_PUB_MS)
    {
      lastImuPub = millis();
      char imuBuf[PAYLOAD_MAX_LEN];
      seq++;
      buildImuPayload(imuBuf, sizeof(imuBuf), imuS, millis(), seq);
      if (!publishToTopic(PUB_TOPIC_IMU, imuBuf))
      {
        g_txQueue.push(PUB_TOPIC_IMU, imuBuf);
        mqttReady = false;
        lastAttempt = millis();
      }
    }

    if (mqttReady && millis() - lastGpsPub >= MQTT_GPS_PUB_MS)
    {
      lastGpsPub = millis();
      char gpsBuf[PAYLOAD_MAX_LEN];
      seq++;
      buildGpsPayload(gpsBuf, sizeof(gpsBuf), gpsS, millis(), seq);
      if (!publishToTopic(PUB_TOPIC_GPS, gpsBuf))
      {
        g_txQueue.push(PUB_TOPIC_GPS, gpsBuf);
        mqttReady = false;
        lastAttempt = millis();
      }
    }

    if (mqttReady && millis() - lastCellPub >= CELL_PUB_MS)
    {
      lastCellPub = millis();
      char cellBuf[PAYLOAD_MAX_LEN];
      seq++;
      buildCellPayload(cellBuf, sizeof(cellBuf), cellS, millis(), seq);
      if (!publishToTopic(PUB_TOPIC_CELL, cellBuf))
      {
        g_txQueue.push(PUB_TOPIC_CELL, cellBuf);
        mqttReady = false;
        lastAttempt = millis();
      }
    }

    if (mqttReady && millis() - lastLivePub >= PUB_INTERVAL_MS)
    {
      lastLivePub = millis();
      char buf[PAYLOAD_MAX_LEN];
      seq++;
      buildLivePayload(buf, sizeof(buf), gpsS, imuS, battS, cellS, seq, false);

      if (!publishToTopic(PUB_TOPIC_LIVEDATA, buf))
      {
        g_txQueue.push(PUB_TOPIC_LIVEDATA, buf);
        mqttReady = false;
        lastAttempt = millis();
      }
    }

    if (millis() - lastSeqSave > 5000 && seq != lastSavedSeq)
    {
      lastSeqSave = millis();
      prefs.putUInt("seq", seq);
      lastSavedSeq = seq;
    }

    vTaskDelay(pdMS_TO_TICKS(20));
  }
}
