#include "battery_module.h"

#include "config.h"
#include "shared_state.h"

#include <Arduino.h>
#include <esp_task_wdt.h>
#include <math.h>

namespace
{
struct FilteredResult
{
  float raw_mv;
};

class KalmanFilter
{
  float q;
  float r;
  float p;
  float k;
  float x;
  bool initialized;

public:
  KalmanFilter(float process_noise, float measurement_noise)
      : q(process_noise), r(measurement_noise), p(1.0f), k(0.0f), x(0.0f),
        initialized(false)
  {
  }

  float filter(float measurement)
  {
    if (!initialized)
    {
      x = measurement;
      initialized = true;
      return x;
    }
    p += q;
    k = p / (p + r);
    x += k * (measurement - x);
    p = (1 - k) * p;
    return x;
  }
};

int g_lastBatteryPin = -1;

uint32_t stableAnalogReadMilliVolts(int pin)
{
  analogReadMilliVolts(pin);
  delayMicroseconds(300);
  return analogReadMilliVolts(pin);
}

void settleAdcMuxForPin(int pin)
{
  if (g_lastBatteryPin == pin)
    return;

  for (int i = 0; i < BATT_PIN_SWITCH_SETTLE; i++)
  {
    analogReadMilliVolts(pin);
    delayMicroseconds(BATT_SAMPLE_DELAY_US);
  }
  g_lastBatteryPin = pin;
}

float robustTapReadMv(int pin)
{
  uint16_t readings[BATT_HIACC_SAMPLES];

  settleAdcMuxForPin(pin);

  for (int i = 0; i < BATT_HIACC_SAMPLES; i++)
  {
    readings[i] = (uint16_t)stableAnalogReadMilliVolts(pin);
    delayMicroseconds(BATT_SAMPLE_DELAY_US);
  }

  for (int i = 1; i < BATT_HIACC_SAMPLES; i++)
  {
    uint16_t key = readings[i];
    int j = i - 1;
    while (j >= 0 && readings[j] > key)
    {
      readings[j + 1] = readings[j];
      j--;
    }
    readings[j + 1] = key;
  }

  const int start = BATT_TRIM_COUNT;
  const int end = BATT_HIACC_SAMPLES - BATT_TRIM_COUNT;
  uint32_t sum = 0;
  for (int i = start; i < end; i++)
    sum += readings[i];

  const float trimmedMean = (float)sum / (float)(end - start);
  const float median = readings[BATT_HIACC_SAMPLES / 2];
  return (trimmedMean * 0.8f) + (median * 0.2f);
}

FilteredResult readCell(int pin)
{
  FilteredResult r;
  r.raw_mv = robustTapReadMv(pin);
  return r;
}

float tapMvToVoltage(float mv, float scale)
{
  return (mv / 1000.0f) * scale;
}

float clampVoltage(float v)
{
  if (v < CELL_MIN_V)
    return CELL_MIN_V;
  if (v > CELL_MAX_V)
    return CELL_MAX_V;
  return v;
}
} // namespace

void batteryTask(void *pv)
{
  (void)pv;
  esp_task_wdt_add(NULL);

  KalmanFilter k1(KALMAN_Q, KALMAN_R);
  KalmanFilter k2(KALMAN_Q, KALMAN_R);
  KalmanFilter k3(KALMAN_Q, KALMAN_R);

  for (;;)
  {
    FilteredResult b3 = readCell(B3_PIN);
    FilteredResult b2 = readCell(B2_PIN);
    FilteredResult b1 = readCell(B1_PIN);

    float B1_v = tapMvToVoltage(b1.raw_mv, SCALE_FACTOR_B1) * TAP_CAL_MUL_B1;
    float B2_v = tapMvToVoltage(b2.raw_mv, SCALE_FACTOR_B2) * TAP_CAL_MUL_B2;
    float B3_v = tapMvToVoltage(b3.raw_mv, SCALE_FACTOR_B3) * TAP_CAL_MUL_B3;

    if (B2_v < B1_v)
      B2_v = B1_v;
    if (B3_v < B2_v)
      B3_v = B2_v;

    float c1 = B1_v + CELL1_OFFSET;
    float c2 = (B2_v - B1_v) + CELL2_OFFSET;
    float c3 = (B3_v - B2_v) + CELL3_OFFSET;
    if (c2 < 0)
      c2 = 0;
    if (c3 < 0)
      c3 = 0;

    c1 = clampVoltage(c1);
    c2 = clampVoltage(c2);
    c3 = clampVoltage(c3);

    float f1 = k1.filter(c1);
    float f2 = k2.filter(c2);
    float f3 = k3.filter(c3);

    BatterySnapshot snap;
    snap.cell1 = f1;
    snap.cell2 = f2;
    snap.cell3 = f3;
    snap.total = f1 + f2 + f3;
    snap.imbalance = fmaxf(fmaxf(f1, f2), f3) - fminf(fminf(f1, f2), f3);
    snap.tap1 = B1_v;
    snap.tap2 = B2_v;
    snap.tap3 = B3_v;

    if (xSemaphoreTake(g_stateMutex, pdMS_TO_TICKS(50)) == pdTRUE)
    {
      g_state.batt = snap;
      xSemaphoreGive(g_stateMutex);
    }

    if (snap.imbalance > 0.10f)
      Serial.printf("[BATT] WARNING cell imbalance %.2fV\n", snap.imbalance);

    esp_task_wdt_reset();
    vTaskDelay(pdMS_TO_TICKS(BATT_INTERVAL_MS));
  }
}
