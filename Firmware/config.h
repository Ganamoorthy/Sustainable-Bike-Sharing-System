#pragma once

#include <Arduino.h>

// -- I2C / IMU --
#define SDA_PIN 21
#define SCL_PIN 22
#define G_TO_MPS2 9.80665f

// -- UART pins --
static const int MODEM_RX = 17;
static const int MODEM_TX = 16;
static const int GPS_RX = 26;
static const int GPS_TX = 27;

// -- Battery ADC pins / calibration --
#define B1_PIN 34
#define B2_PIN 35
#define B3_PIN 32
#define SCALE_FACTOR_B1 4.066233333333333f
#define SCALE_FACTOR_B2 4.066233333333333f
#define SCALE_FACTOR_B3 4.066233333333333f
#define TAP_CAL_MUL_B1 4.655f
#define TAP_CAL_MUL_B2 1.148f
#define TAP_CAL_MUL_B3 1.086f
#define CELL1_OFFSET (1.11f)
#define CELL2_OFFSET (-1.68f)
#define CELL3_OFFSET (0.18f)
#define BATT_HIACC_SAMPLES 64
#define BATT_TRIM_COUNT 8
#define BATT_PIN_SWITCH_SETTLE 4
#define BATT_SAMPLE_DELAY_US 350
#define KALMAN_Q 0.0005f
#define KALMAN_R 0.01f
#define CELL_MIN_V 0.0f
#define CELL_MAX_V 4.5f

#if (BATT_HIACC_SAMPLES <= (BATT_TRIM_COUNT * 2))
#error "BATT_HIACC_SAMPLES must be > 2 * BATT_TRIM_COUNT"
#endif

// -- Cellular / MQTT --
static const char *APN = "hutch3g";
static const char *BROKER = "4.206.218.6";
static const int PORT = 1883;
static const char *BIKE_ID = "AUKxE7WkcCrdD6Vpst6A";
static const char *CLIENT_ID = BIKE_ID;
static const char *MQTT_USER = "test1";
static const char *MQTT_PASS = "Test1234";
static const char *PUB_TOPIC_LIVEDATA = "/mybike/livedata";
static const char *PUB_TOPIC_IMU = "/mybike/imu";
static const char *PUB_TOPIC_GPS = "/mybike/gps";
static const char *PUB_TOPIC_CELL = "/mybike/cell";
static const char *ALERT_TOPIC = "/mybike/alert";
static const char *DEVICE_ID = BIKE_ID;
static const char *FW_VERSION = "4.0.1";

// -- Timing --
static const uint32_t PUB_INTERVAL_MS = 1000;
static const uint32_t IMU_PERIOD_MS = 20;
static const uint32_t BATT_INTERVAL_MS = 1000;
static const uint32_t MQTT_IMU_PUB_MS = 50;
static const uint32_t MQTT_GPS_PUB_MS = 200;
static const uint32_t CELL_QUERY_MS = 10000;
static const uint32_t CELL_PUB_MS = 5000;
static const uint32_t GPS_STALE_MS = 3000;
static const uint32_t RECONNECT_BASE_MS = 2000;
static const uint32_t RECONNECT_MAX_MS = 60000;
static const uint32_t WDT_TIMEOUT_S = 20;
static const int MAX_CONSEC_MQTT_FAILURES = 5;

// -- Crash/jolt heuristic (placeholder for future TinyML model) --
static const float JOLT_THRESHOLD_MPS2 = 2.5f * G_TO_MPS2;
static const float GYRO_JOLT_DPS = 250.0f;

// -- Offline buffering --
#define TX_QUEUE_LEN 20
#define PAYLOAD_MAX_LEN 320
#define TOPIC_MAX_LEN 64
