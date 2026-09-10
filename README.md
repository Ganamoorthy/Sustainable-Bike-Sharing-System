# 🚲 IoT-Based Smart Bike Sharing System

*Solar-Assisted Charging & Smart Docking — with Energy Harvesting/Transfer as Future Work*

<p align="center">

**A Low-Cost IoT-Based Smart Bicycle Sharing System for Universities and Small Urban Environments**

</p>

<p align="center">

![ESP32](https://img.shields.io/badge/ESP32-Embedded%20System-blue)
![GPS](https://img.shields.io/badge/GPS-Tracking-green)
![4G LTE](https://img.shields.io/badge/4G%20LTE-Air780E-orange)
![MQTT](https://img.shields.io/badge/MQTT-IoT-purple)
![NFC](https://img.shields.io/badge/NFC-Authentication-red)
![FreeRTOS](https://img.shields.io/badge/FreeRTOS-Multitasking-yellow)
![Research](https://img.shields.io/badge/Final%20Year-Research-success)

</p>

---

## 📌 Project Overview

The **IoT-Based Smart Bike Sharing System** is a one-year final-year research project focused on developing a **low-cost, IoT-enabled bicycle-sharing system** for universities, campuses and small urban environments.

The system integrates **GPS tracking, IMU sensing, 4G LTE communication, MQTT, NFC authentication, smart docking, battery monitoring, solar charging, mobile application and cloud-based IoT services** into a single platform.

The project focuses on creating a practical and scalable alternative to expensive commercial bicycle-sharing infrastructure.

---

# 🎯 Research Objective

The main objective is to design and develop a **low-cost smart bicycle-sharing platform** capable of:

* Monitoring bicycle location and movement
* Providing secure user authentication
* Managing bicycle docking
* Monitoring battery condition
* Communicating through cellular networks
* Sending real-time IoT data to a backend
* Supporting solar-based charging
* Providing a foundation for future energy harvesting and transfer

### Target environments

* Universities
* University campuses
* Small cities
* Private campuses
* Controlled bicycle-sharing environments

---

# ✨ Main System Features

| Feature               | Description                                          |
| --------------------- | ---------------------------------------------------- |
| 📍 GPS Tracking       | Tracks bicycle location using GPS                    |
| 🧭 IMU Sensing        | Detects movement and provides motion data            |
| 📡 4G LTE             | Provides remote cellular connectivity                |
| 📬 MQTT               | Lightweight IoT communication protocol               |
| 🔐 NFC Authentication | Identifies and authenticates users                   |
| 🅿️ Smart Docking     | Manages bicycle docking                              |
| 🔒 Electronic Locking | Solenoid-based locking mechanism                     |
| 🔋 Battery Monitoring | Monitors battery and individual cell voltages        |
| ☀️ Solar Charging     | Provides supplementary battery charging              |
| 📱 Mobile Application | User interface for the bike-sharing system           |
| ☁️ IoT Backend        | Receives and manages system data                     |
| 🧩 Custom PCB         | Integrates electronic components                     |
| 🖨️ 3D Printing       | Supports mechanical integration and enclosure design |

---

# 🚀 Getting Started

## Requirements

* Arduino IDE 2.x (or PlatformIO)
* ESP32 board package installed via the Arduino Boards Manager
* USB-to-serial driver for your ESP32 dev board (CP2102 or CH340, depending on the board)

## Required Libraries

Install via Library Manager or PlatformIO's `lib_deps`:

* **TinyGPSPlus** — GPS NMEA parsing
* **PubSubClient** — MQTT communication
* **ArduinoJson** — payload formatting
* **Preferences** — bundled with the ESP32 core, used for persistent sequence numbers

## Flashing the Firmware

1. Clone the repository: `git clone <repo-url>`
2. Open `firmware/tracking/sketch_sep3a.ino` in Arduino IDE
3. Select board **ESP32 Dev Module** and the correct COM port
4. Update `config.h` with your MQTT broker address, APN, and Wi-Fi/cellular credentials
5. Upload the sketch
6. Open the Serial Monitor at 115200 baud to confirm GPS fix, MQTT connection, and battery readings

## Notes

* The docking firmware (`firmware/docking/`) is a separate sketch, flashed to its own ESP32
* Connect the GPS and cellular antennas before powering on — otherwise the modules may fail to register

---

# 🏗️ Overall System Architecture

```text
                         ┌─────────────────────┐
                         │    Mobile App       │
                         │                     │
                         │ User Interface      │
                         │ Bike Information    │
                         │ Tracking            │
                         │ Authentication      │
                         └──────────┬──────────┘
                                    │
                                    ▼
                         ┌─────────────────────┐
                         │   IoT / Backend     │
                         │                     │
                         │ MQTT Broker         │
                         │ Database            │
                         │ Server              │
                         └──────────┬──────────┘
                                    │
                              MQTT over 4G
                                    │
                                    ▼
                ┌───────────────────────────────────┐
                │        Bicycle Tracking Unit      │
                │                                   │
                │              ESP32                │
                │                                   │
                │   ┌────────┐    ┌────────────┐    │
                │   │  GPS   │    │    IMU     │    │
                │   └────────┘    └────────────┘    │
                │                                   │
                │        ┌─────────────────┐        │
                │        │ Air780E 4G LTE  │        │
                │        └─────────────────┘        │
                │                                   │
                │   ┌──────────┐ ┌──────────────┐   │
                │   │ Battery  │ │ Solar        │   │
                │   │ System   │ │ Charging     │   │
                │   └──────────┘ └──────────────┘   │
                └────────────────┬──────────────────┘
                                 │
                                 ▼
                       ┌─────────────────────┐
                       │ Smart Docking Unit  │
                       │                     │
                       │ NFC Authentication  │
                       │ Solenoid Lock       │
                       │ Relay / Driver      │
                       │ Docking Mechanism   │
                       └─────────────────────┘
```

---

# 🚲 Bike Tracking System

The tracking subsystem is responsible for monitoring the bicycle's **location, movement and system status** and transmitting the collected information to the IoT backend.

## Main Components

* ESP32 Development Board
* NEO-6M GPS Module
* NEO-8M GPS Module
* Air780E 4G LTE Module
* SIM800L GSM Module
* ICM-20948 IMU
* MPU9250 IMU
* GPS antenna
* Cellular antenna
* 3 × 18650 Li-ion batteries
* 3S BMS / HW-288
* LM2596 buck converters
* Custom PCB

> **Note:** NEO-6M/NEO-8M, ICM-20948/MPU9250 and Air780E/SIM800L were each evaluated as alternatives during development. See the Budget section for which components are costed into the final prototype versus tested as options.

---

# 📍 GPS Tracking

GPS is used to determine the geographic position of the bicycle.

Two GPS modules were evaluated during development:

### NEO-6M

A low-cost GPS receiver used for prototype development and testing.

### NEO-8M

A higher-end GPS receiver evaluated for comparison and positioning performance.

The tracking firmware processes GPS information including:

* Latitude
* Longitude
* Fix validity
* Number of satellites
* HDOP
* Speed
* Altitude
* GPS time

The firmware also performs **stale-data and validity checking** to prevent outdated GPS information from being incorrectly treated as a new position.

---

# 🧭 IMU-Based Motion Monitoring

The project evaluated two IMU modules:

* **ICM-20948**
* **MPU9250**

The IMU provides motion-related measurements and supports bicycle movement monitoring.

The final firmware also includes **strong-jolt detection**.

```text
IMU Data
   │
   ▼
Motion Processing
   │
   ├── Normal Movement
   │
   └── Strong Jolt
          │
          ▼
      Alert Event
```

---

# 📡 4G LTE Communication

The **Air780E 4G LTE module** is used to provide cellular connectivity for the bicycle tracking system.

The ESP32 communicates with the Air780E through UART and AT commands.

```text
ESP32
  │
  │ UART / AT Commands
  ▼
Air780E
  │
  │ 4G LTE
  ▼
Internet
  │
  ▼
MQTT Broker
  │
  ▼
Backend / Application
```

This allows the bicycle to communicate with the backend without depending on local Wi-Fi.

---

# 📬 MQTT Communication

The final tracking system uses **MQTT** as the IoT communication protocol.

MQTT provides lightweight publish/subscribe communication between the bicycle and backend infrastructure.

### Main MQTT Topics

```text
/mybike/livedata
/mybike/imu
/mybike/gps
/mybike/cell
/mybike/alert
```

Different topics are used to separate live tracking, GPS, IMU, cellular and alert information.

---

# 🧠 Advanced Firmware Architecture

The final firmware uses a **modular FreeRTOS-based architecture**.

```text
                 ESP32
                   │
        ┌──────────┼──────────┐
        │          │          │
        ▼          ▼          ▼
     GPS Task   IMU Task   Battery Task
        │          │          │
        └──────────┼──────────┘
                   ▼
             Shared State
             + Mutex
                   │
                   ▼
             Network Task
                   │
                   ▼
              Air780E
                   │
                   ▼
             MQTT Broker
```

### Firmware modules

```text
config.h
shared_state.*
sensor_tasks.*
battery_module.*
network_module.*
sketch_sep3a.ino
```

This modular structure improves:

* Readability
* Maintainability
* Debugging
* Testing
* Future development

---

# ⚙️ FreeRTOS Multi-Tasking

Separate FreeRTOS tasks are used for:

* GPS processing
* IMU processing
* Battery monitoring
* Network/MQTT communication

The tasks are distributed across the ESP32 processing cores to improve system responsiveness.

---

# 🔒 Thread-Safe Shared Data

Sensor information is shared through a common state structure protected by:

```text
g_stateMutex
```

The mutex prevents multiple tasks from accessing shared data simultaneously and reduces the possibility of race conditions.

---

# 🛡️ Watchdog Protection

Major tasks periodically reset the watchdog during normal operation.

If a task becomes unresponsive, the watchdog mechanism can detect the problem and support system recovery.

This improves reliability during long-term operation.

---

# 🔋 Advanced Battery Monitoring

The firmware implements advanced processing for battery measurement.

### Techniques used

* ADC oversampling
* Trimmed filtering
* Kalman smoothing
* Per-cell voltage calculation
* Cell imbalance detection

```text
ADC
 │
 ▼
Oversampling
 │
 ▼
Trimmed Filtering
 │
 ▼
Kalman Smoothing
 │
 ▼
Battery Voltage
 │
 ├── Cell 1
 ├── Cell 2
 ├── Cell 3
 └── Imbalance Detection
```

---

# 📶 Cellular Location Fallback

When GPS information is weak or unavailable, the firmware collects cellular network information from the Air780E.

The collected information includes:

```text
MCC
MNC
LAC
Cell ID
RSSI
```

The data can be used by the backend for **cell-tower-based location estimation**.

---

# 🏷️ Location Source Tagging

The live-data payload identifies the current location source.

```text
src = G
```

**GPS location**

```text
src = C
```

**Cellular fallback**

This allows the backend to distinguish between GPS-based and cellular-based positioning information.

---

# 🔄 Network Recovery

The firmware includes several mechanisms to handle communication failures.

### MQTT Reconnection

An **exponential backoff** strategy is used to avoid repeated rapid reconnection attempts.

### Modem Recovery

After repeated communication failures, the Air780E can be soft-reset using:

```text
AT+CFUN=1,1
```

This allows the communication subsystem to attempt automatic recovery without manual intervention.

---

# 💾 Offline Message Queue

When MQTT publishing fails, messages can be temporarily stored in an offline queue.

```text
Message
   │
   ▼
MQTT Publish
   │
 ┌─┴──────┐
 │        │
Success  Failed
 │        │
 ▼        ▼
Sent     Queue
           │
           ▼
      Connection Restored
           │
           ▼
        Retry
```

When the queue reaches its maximum capacity, the oldest message is removed to allow newer messages to be stored.

---

# 🔐 Data Integrity and Message Ordering

The firmware implements lightweight data integrity and ordering mechanisms.

### XOR Checksum

An XOR checksum is included with payload data to help detect data corruption.

### Persistent Sequence Number

Message sequence numbers are stored using ESP32 Preferences/flash storage.

This allows the sequence to continue across device reboots.

---

# 🖥️ Runtime Diagnostics

The firmware provides periodic serial debugging information including:

* GPS status
* MQTT/network status
* Battery voltage
* Individual cell voltages
* Cell imbalance
* System state
* Sensor information

This is useful for testing, troubleshooting and prototype validation.

---

# 🅿️ Smart Docking and Locking

The docking subsystem provides controlled bicycle docking and locking.

## Main Components

* ESP32 Development Boards
* Solenoid locks
* Relay/driver modules
* NFC readers
* NFC cards
* Buzzers
* Custom PCB
* 3D-printed mechanical parts
* Mechanical hardware
* Welding/fabrication components

### Basic Operation

```text
Bicycle Arrives
      │
      ▼
Dock Detection
      │
      ▼
NFC Authentication
      │
      ▼
Lock / Unlock Control
      │
      ▼
Bicycle Secured
      │
      ▼
System Status Update
```

---

# 🔐 NFC Authentication

NFC is used to identify and authenticate users.

```text
NFC Card
   │
   ▼
NFC Reader
   │
   ▼
ESP32
   │
   ├── Valid → Allow Operation
   │
   └── Invalid → Reject Access
```

This provides a simple physical authentication mechanism for the bicycle-sharing system.

---

# 🔋 Power System

The tracking system uses a rechargeable battery configuration consisting of:

* 3 × 18650 Li-ion cells
* 3.7 V nominal cell voltage
* 3200 mAh rated capacity per cell
* 3S BMS / HW-288
* LM2596 buck converters

### Power Architecture

```text
3 × 18650 Battery
        │
        ▼
      3S BMS
        │
        ▼
 Main Power Rail
        │
        ├──► ESP32
        ├──► GPS
        ├──► Air780E
        └──► IMU / Electronics
```

---

# ☀️ Solar Charging System

A small solar charging subsystem was developed as part of the prototype.

### Components

* 2 × 5 V / 30 mA solar panels
* 3S BMS / HW-288
* Fuse
* LM2596 buck converter

```text
Solar Panel
     │
     ▼
Power Conditioning
     │
     ▼
Battery Management
     │
     ▼
Battery
```

The solar subsystem provides supplementary charging capability.

---

# 📱 Mobile Application

The mobile application provides the user-facing interface for the bike-sharing platform.

Main functions include:

* User interaction
* Bicycle information
* Bicycle availability
* Tracking information
* Authentication
* Ride-related information
* System status

---

# ☁️ IoT Backend

The backend receives and manages data transmitted from the bicycle.

```text
Sensors
   │
   ▼
ESP32
   │
   ▼
Air780E
   │
   ▼
4G LTE
   │
   ▼
MQTT Broker
   │
   ▼
Backend
   │
   ├──► Database
   │
   └──► Mobile Application
```

The backend can manage:

* Bicycle information
* User information
* Location
* Movement status
* Ride information
* Docking status
* Alerts
* System events

---

# 🧩 Hardware Development

The hardware was developed through several stages:

```text
Concept
  ↓
Component Selection
  ↓
Breadboard Prototype
  ↓
Individual Module Testing
  ↓
Subsystem Integration
  ↓
Custom PCB
  ↓
3D-Printed Integration
  ↓
Complete Prototype
  ↓
Testing & Evaluation
```

Custom PCBs were developed to improve integration and reduce wiring complexity.

---

# 🖨️ 3D-Printed Mechanical Design

3D printing was used for:

* Enclosures
* Component mounting
* Mechanical parts
* Docking components
* Prototype integration

The development workflow included modelling, printing, assembly and mechanical testing.

---

# 🧪 Research Methodology

The project was conducted over one academic year using an iterative engineering research methodology.

```text
Literature Review
       ↓
Problem Identification
       ↓
Requirements
       ↓
System Design
       ↓
Component Selection
       ↓
Prototype Development
       ↓
Subsystem Testing
       ↓
System Integration
       ↓
Experimental Testing
       ↓
Performance Evaluation
       ↓
Final Prototype
```

---

# 🧪 Testing and Evaluation

Testing was carried out at both subsystem and complete-system levels.

### Tracking

* NEO-6M GPS testing
* NEO-8M GPS testing
* GPS accuracy evaluation
* Satellite and HDOP monitoring
* IMU testing
* Movement detection
* Jolt detection
* Cellular communication
* MQTT communication

### Battery

* Battery voltage measurement
* Individual cell voltage monitoring
* Cell imbalance detection
* Current consumption
* BMS operation
* Solar charging

### Docking

* NFC authentication
* Solenoid locking
* Relay/driver operation
* Docking mechanism
* Mechanical testing

### Integrated System

* GPS data transmission
* MQTT communication
* Backend integration
* Mobile application interaction
* Bicycle docking
* Authentication
* Long-term firmware operation

---

# 💰 Project Budget

## A. Bike Tracking System

| Component                      |   Qty | Unit Price (LKR) |    Total (LKR) |
| ------------------------------ | ----: | ---------------: | -------------: |
| ESP32 Development Board 30-pin |     1 |            1,260 |          1,260 |
| NEO-6M GPS Module              |     1 |            1,000 |          1,000 |
| NEO-8M GPS Module              |     1 |            3,400 |          3,400 |
| Air780E 4G LTE Module          |     1 |            5,100 |          5,100 |
| SIM800L GSM Module             |     1 |            1,650 |          1,650 |
| ICM-20948 IMU                  |     1 |            6,487 |          6,487 |
| MPU9250 IMU                    |     1 |              750 |            750 |
| 18650 3.7 V 3200 mAh Battery   |     3 |              840 |          2,520 |
| 3S BMS / HW-288                |     1 |             500* |            500 |
| LM2596 Buck Converter          |     2 |              220 |            440 |
| GPS Antenna                    |     1 |              900 |            900 |
| 4G/Cellular Antenna            |     1 |            1,560 |          1,560 |
| Custom PCB                     |     1 |           1,500* |          1,500 |
| Connectors / Wires             | 1 lot |             500* |            500 |
| **Subtotal**                   |       |                  | **LKR 27,567** |

---

## B. Bike Locking / Docking System

| Component                        |   Qty | Unit Price (LKR) |    Total (LKR) |
| --------------------------------- | ----: | ---------------: | -------------: |
| ESP32 Development Board 30-pin   |     2 |            1,260 |          2,520 |
| Solenoid Lock                    |     4 |           1,450* |          5,800 |
| Relay / Driver Module            |     4 |              220 |            880 |
| Buzzer                           |     2 |               50 |            100 |
| Custom PCB                       |     1 |           1,500* |          1,500 |
| Wires / Connectors               | 1 lot |             500* |            500 |
| 3D-Printed Mechanical Parts      | 1 set |           1,000* |          1,000 |
| Screws / Nuts / Mechanical Parts | 1 lot |             300* |            300 |
| NFC Reader                       |     2 |           1,150* |          2,300 |
| NFC Card                         |     2 |              50* |            100 |
| Welding Work / Components        | 1 lot |            9,000 |          9,000 |
| Linear Actuator – Testing        |     1 |            3,500 |          3,500 |
| **Subtotal**                     |       |                  | **LKR 27,500** |

---

## C. Solar Charging System

| Component                       | Qty | Unit Price (LKR) |   Total (LKR) |
| -------------------------------- | --: | ---------------: | ------------: |
| 3S BMS / HW-288                 |   1 |             500* |           500 |
| Fuse                            |   1 |              40* |            40 |
| LM2596 Buck Converter           |   1 |             220* |           220 |
| Small Solar Panel – 5 V / 30 mA |   2 |              350 |           700 |
| **Subtotal**                    |     |                  | **LKR 1,460** |

---

## D. 3D Printing / Enclosure

| Component                                 |   Qty |   Total (LKR) |
| ------------------------------------------ | ----: | ------------: |
| 3D Printing Filament / Enclosure Material | 1 lot |         5,500 |
| **Subtotal**                              |       | **LKR 5,500** |

---

## 💵 Final Budget Summary

| Section                       |           Cost |
| ------------------------------ | -------------: |
| Bike Tracking System          |     LKR 27,567 |
| Bike Locking / Docking System |     LKR 27,500 |
| Solar Charging System         |      LKR 1,460 |
| 3D Printing / Enclosure       |      LKR 5,500 |
| **Overall Total**             | **LKR 62,027** |

`*` Approximate/local prototype cost.

---

# 🛠️ Technology Stack

## Embedded

* ESP32
* FreeRTOS
* C/C++
* Arduino IDE

## Sensors & Modules

* NEO-6M
* NEO-8M
* ICM-20948
* MPU9250
* Air780E
* SIM800L
* NFC Reader

## Communication

* UART
* I²C
* SPI
* 4G LTE
* MQTT

## Hardware Design

* Custom PCB
* Breadboard prototyping
* Electronic testing
* 3D modelling
* 3D printing

## Software

* Mobile Application
* IoT Backend
* MQTT Broker
* Database
* Git/GitHub

---

# 📁 Repository Structure

```text
Sustainable-Bike-Sharing-System/
│
├── README.md
│
├── firmware/
│   ├── tracking/
│   │   ├── config.h
│   │   ├── shared_state.*
│   │   ├── sensor_tasks.*
│   │   ├── battery_module.*
│   │   ├── network_module.*
│   │   └── sketch_sep3a.ino
│   │
│   └── docking/
│
├── hardware/
│   ├── schematics/
│   ├── pcb/
│   ├── wiring/
│   └── bom/
│
├── mobile_app/
│
├── backend/
│   ├── mqtt/
│   ├── api/
│   └── database/
│
├── mechanical/
│   ├── 3d_models/
│   ├── enclosures/
│   └── drawings/
│
├── research/
│   ├── literature_review/
│   ├── methodology/
│   ├── experiments/
│   └── results/
│
├── documentation/
│
├── media/
│   ├── prototype/
│   ├── hardware/
│   ├── pcb/
│   └── testing/
│
├── LICENSE
└── .gitignore
```

---

# ⚠️ Current Limitations

As a research prototype, the current system has several limitations:

* GPS accuracy depends on environmental conditions.
* IMU-based positioning can accumulate error.
* Cellular communication depends on network coverage.
* Solar charging output is limited by panel capacity and environmental conditions.
* Prototype mechanical components require further durability testing.
* Long-term field testing is required before large-scale deployment.
* Battery performance requires extended real-world evaluation.

---

# 🔮 Future Developments

The following are **future research directions** and are not claimed as completed features of the current prototype.

### ⚡ Energy Harvesting

Future versions can investigate more efficient energy harvesting from bicycle operation using:

* Dynamo systems
* Piezoelectric elements
* Improved power conditioning
* Advanced energy storage

### 🔌 Energy Transfer

Future research can investigate:

* Automated charging contacts
* Improved transfer efficiency
* Contactless energy transfer
* Dock-based charging

### 📍 Advanced Positioning

Future improvements could include:

* Advanced GNSS
* Sensor fusion
* Improved dead reckoning
* Kalman-based sensor fusion
* RTK positioning
* Map matching

### 🔋 Intelligent Battery Management

Potential improvements include:

* Advanced State-of-Charge estimation
* State-of-Health estimation
* Battery fault detection
* Predictive maintenance
* Improved cell-level monitoring

### 🌐 Large-Scale Deployment

Future work could investigate:

* Multiple bicycles
* Multiple docking stations
* Fleet management
* Real-time analytics
* Remote diagnostics
* Scalable MQTT infrastructure

---

# 🎓 Research Contribution

The project demonstrates the integration of multiple technologies into a **low-cost smart bicycle-sharing platform**.

The major technical contribution is the combination of:

```text
GPS
 +
IMU
 +
4G LTE
 +
MQTT
 +
NFC
 +
Smart Docking
 +
Battery Monitoring
 +
Solar Charging
 +
Mobile Application
 +
IoT Backend
```

The project also demonstrates an advanced embedded firmware architecture using **FreeRTOS multitasking, multi-core processing, thread-safe shared data, watchdog protection, sensor filtering, cellular fallback, offline message queuing and persistent message sequencing**.

---

# 👥 Academic Project

**Project Type:** Final Year Research Project
**Duration:** One Academic Year
**Degree:** Bachelor of Science Honours in Electronics and Computer Science
**University:** University of Kelaniya

### Research Title

> **IoT-Based Smart Bike Sharing System**

---

# 📜 License

This repository is released under the [MIT License](LICENSE). Feel free to use, modify and build on this work for academic or research purposes, with attribution.

---

# 🙏 Acknowledgements

We would like to acknowledge the support and guidance provided by:

* University of Kelaniya
* Academic supervisors
* Department staff
* Laboratory staff
* Project collaborators
* Individuals and organizations who supported prototype development and testing

---

# 🚲 Project Summary

The **IoT-Based Smart Bike Sharing System** is a low-cost IoT-based bicycle-sharing research platform integrating:

**GPS Tracking • IMU Sensing • 4G LTE • MQTT • NFC Authentication • Smart Docking • Battery Monitoring • Solar Charging • Mobile Application • IoT Backend**

The developed prototype demonstrates how **embedded systems, wireless communication, sensing, software, energy management and mechanical design** can be combined to create a practical smart mobility solution.

Future research will focus on **advanced energy harvesting, energy transfer, positioning improvement, intelligent battery management and large-scale deployment**.

<p align="center">

### 🚲 Smart Mobility • 📍 Intelligent Tracking • 📡 IoT • 🔐 Secure Access • ☀️ Sustainable Technology

</p>
