#include "sensor_tasks.h"

#include "config.h"
#include "shared_state.h"

#include <Arduino.h>
#include <Wire.h>
#include <esp_task_wdt.h>
#include <math.h>

namespace
{
bool initIMU()
{
  Wire.begin(SDA_PIN, SCL_PIN);
  Wire.setClock(100000);
  delay(1000);

  myICM.begin(Wire, 0);
  Serial.print("[IMU] Init status: ");
  Serial.println(myICM.statusString());

  if (myICM.status != ICM_20948_Stat_Ok)
  {
    Serial.println("[IMU] init failed");
    return false;
  }
  Serial.println("[IMU] connected");
  return true;
}
} // namespace

void gpsTask(void *pv)
{
  (void)pv;
  esp_task_wdt_add(NULL);
  uint32_t lastSnap = 0;

  for (;;)
  {
    while (gpsSerial.available())
      gps.encode(gpsSerial.read());

    if (millis() - lastSnap >= 200)
    {
      lastSnap = millis();

      GpsSnapshot snap;
      snap.fixValid = gps.location.isValid() &&
                      gps.location.age() <= GPS_STALE_MS &&
                      (!gps.satellites.isValid() || gps.satellites.value() > 0);
      snap.lat = snap.fixValid ? gps.location.lat() : 0.0;
      snap.lon = snap.fixValid ? gps.location.lng() : 0.0;
      snap.alt = gps.altitude.isValid() ? gps.altitude.meters() : 0.0;
      snap.sats = gps.satellites.isValid() ? gps.satellites.value() : 0;
      snap.hdop = gps.hdop.isValid() ? gps.hdop.hdop() : 99.9;
      snap.speedKmh = gps.speed.isValid() ? gps.speed.kmph() : 0.0;
      if (gps.time.isValid())
      {
        snap.hh = gps.time.hour();
        snap.mm = gps.time.minute();
        snap.ss = gps.time.second();
      }

      if (xSemaphoreTake(g_stateMutex, pdMS_TO_TICKS(50)) == pdTRUE)
      {
        g_state.gps = snap;
        xSemaphoreGive(g_stateMutex);
      }
    }

    esp_task_wdt_reset();
    vTaskDelay(pdMS_TO_TICKS(10));
  }
}

void imuTask(void *pv)
{
  (void)pv;
  esp_task_wdt_add(NULL);
  bool imuReady = initIMU();

  for (;;)
  {
    if (imuReady && myICM.dataReady())
    {
      myICM.getAGMT();

      float ax = (myICM.accX() / 1000.0f) * G_TO_MPS2;
      float ay = (myICM.accY() / 1000.0f) * G_TO_MPS2;
      float az = (myICM.accZ() / 1000.0f) * G_TO_MPS2;
      float gx = myICM.gyrX();
      float gy = myICM.gyrY();
      float gz = myICM.gyrZ();
      float mx = myICM.magX();
      float my_ = myICM.magY();
      float mz = myICM.magZ();
      float t = myICM.temp();

      float mag = sqrtf(ax * ax + ay * ay + az * az);
      bool jolt = (fabsf(mag - G_TO_MPS2) > JOLT_THRESHOLD_MPS2) ||
                  (fabsf(gx) > GYRO_JOLT_DPS || fabsf(gy) > GYRO_JOLT_DPS ||
                   fabsf(gz) > GYRO_JOLT_DPS);

      if (xSemaphoreTake(g_stateMutex, pdMS_TO_TICKS(20)) == pdTRUE)
      {
        g_state.imu.ax = ax;
        g_state.imu.ay = ay;
        g_state.imu.az = az;
        g_state.imu.gx = gx;
        g_state.imu.gy = gy;
        g_state.imu.gz = gz;
        g_state.imu.mx = mx;
        g_state.imu.my = my_;
        g_state.imu.mz = mz;
        g_state.imu.tempC = t;
        if (jolt)
          g_state.imu.joltDetected = true;
        xSemaphoreGive(g_stateMutex);
      }
    }

    esp_task_wdt_reset();
    vTaskDelay(pdMS_TO_TICKS(IMU_PERIOD_MS));
  }
}
