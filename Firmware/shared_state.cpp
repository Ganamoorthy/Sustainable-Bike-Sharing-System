#include "shared_state.h"

SharedState g_state;
SemaphoreHandle_t g_stateMutex = nullptr;

HardwareSerial simSerial(1);
HardwareSerial gpsSerial(2);
TinyGPSPlus gps;
ICM_20948_I2C myICM;
