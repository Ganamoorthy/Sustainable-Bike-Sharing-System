#pragma once

#include "ICM_20948.h"
#include <HardwareSerial.h>
#include <TinyGPSPlus.h>
#include <freertos/FreeRTOS.h>
#include <freertos/semphr.h>

struct GpsSnapshot
{
  bool fixValid = false;
  double lat = 0;
  double lon = 0;
  double alt = 0;
  uint32_t sats = 0;
  double hdop = 99.9;
  double speedKmh = 0;
  uint8_t hh = 0;
  uint8_t mm = 0;
  uint8_t ss = 0;
};

struct ImuSnapshot
{
  float ax = 0;
  float ay = 0;
  float az = 0;
  float gx = 0;
  float gy = 0;
  float gz = 0;
  float mx = 0;
  float my = 0;
  float mz = 0;
  float tempC = 0;
  bool joltDetected = false;
};

struct BatterySnapshot
{
  float cell1 = 0;
  float cell2 = 0;
  float cell3 = 0;
  float total = 0;
  float imbalance = 0;
  float tap1 = 0;
  float tap2 = 0;
  float tap3 = 0;
};

struct CellSnapshot
{
  bool valid = false;
  int mcc = 0;
  int mnc = 0;
  uint8_t mncDigits = 0;
  long lac = -1;
  long cellId = -1;
  int rssiDbm = 0;
  int csqRaw = 99;
  uint8_t regStatus = 0;
};

struct SharedState
{
  GpsSnapshot gps;
  ImuSnapshot imu;
  BatterySnapshot batt;
  CellSnapshot cell;
};

extern SharedState g_state;
extern SemaphoreHandle_t g_stateMutex;

extern HardwareSerial simSerial;
extern HardwareSerial gpsSerial;
extern TinyGPSPlus gps;
extern ICM_20948_I2C myICM;
