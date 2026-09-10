/* ============================================================
   SMART BIKE SHARING - MODULAR ENTRY FILE
   Code is now split into packet-style modules for easier study:
   - config.h            -> constants and tuning
   - shared_state.*      -> global snapshots and shared peripherals
   - sensor_tasks.*      -> GPS + IMU tasks
   - battery_module.*    -> high-accuracy battery pipeline
   - network_module.*    -> AT/MQTT, payloads, queue, publish task
   ============================================================ */

#include "battery_module.h"
#include "config.h"
#include "network_module.h"
#include "sensor_tasks.h"
#include "shared_state.h"

#include <Arduino.h>
#include <esp_task_wdt.h>
#include <freertos/FreeRTOS.h>
#include <freertos/task.h>

void setup()
{
  Serial.begin(115200);
  delay(2000);

  gpsSerial.begin(9600, SERIAL_8N1, GPS_RX, GPS_TX);
  analogReadResolution(12);
  analogSetAttenuation(ADC_11db);

  g_stateMutex = xSemaphoreCreateMutex();

#if ESP_IDF_VERSION_MAJOR >= 5
  esp_task_wdt_config_t wdtConfig = {.timeout_ms = WDT_TIMEOUT_S * 1000,
                                     .idle_core_mask = 0,
                                     .trigger_panic = true};
  esp_task_wdt_init(&wdtConfig);
#else
  esp_task_wdt_init(WDT_TIMEOUT_S, true);
#endif

  xTaskCreatePinnedToCore(gpsTask, "gpsTask", 4096, NULL, 1, NULL, 0);
  xTaskCreatePinnedToCore(networkTask, "netTask", 8192, NULL, 2, NULL, 0);
  xTaskCreatePinnedToCore(imuTask, "imuTask", 4096, NULL, 2, NULL, 1);
  xTaskCreatePinnedToCore(batteryTask, "battTask", 4096, NULL, 1, NULL, 1);

  Serial.println("[SYS] All tasks started");
}

void loop()
{
  static uint32_t lastDebug = 0;
  if (millis() - lastDebug >= 2000)
  {
    lastDebug = millis();

    GpsSnapshot gpsS;
    ImuSnapshot imuS;
    BatterySnapshot battS;
    CellSnapshot cellS;
    if (xSemaphoreTake(g_stateMutex, pdMS_TO_TICKS(50)) == pdTRUE)
    {
      gpsS = g_state.gps;
      imuS = g_state.imu;
      battS = g_state.batt;
      cellS = g_state.cell;
      xSemaphoreGive(g_stateMutex);
    }

    Serial.printf("[STATUS] fix=%d sat=%lu lat=%.4f lon=%.4f | "
                  "tap=%.2f/%.2f/%.2f | batt v1=%.2f v2=%.2f v3=%.2f "
                  "tot=%.2f imb=%.2f | acc=(%.2f,%.2f,%.2f) | "
                  "cell valid=%d mcc=%d mnc=%d lac=%ld cid=%ld\n",
                  gpsS.fixValid, (unsigned long)gpsS.sats, gpsS.lat, gpsS.lon,
                  battS.tap1, battS.tap2, battS.tap3, battS.cell1, battS.cell2,
                  battS.cell3, battS.total, battS.imbalance, imuS.ax, imuS.ay,
                  imuS.az, cellS.valid ? 1 : 0, cellS.mcc, cellS.mnc,
                  cellS.lac, cellS.cellId);
  }
  vTaskDelay(pdMS_TO_TICKS(200));
}
