# 🚲 Sustainable Bike Sharing System with Smart Tracking and Docking

<p align="center">

**A Low-Cost IoT-Based Bicycle Sharing System for Universities and Small Urban Environments**

</p>

<p align="center">

![ESP32](https://img.shields.io/badge/ESP32-Embedded%20System-blue)
![IoT](https://img.shields.io/badge/IoT-IoT%20Enabled-green)
![GPS](https://img.shields.io/badge/GPS-Tracking-orange)
![MQTT](https://img.shields.io/badge/MQTT-Communication-purple)
![4G LTE](https://img.shields.io/badge/4G-LTE-red)
![RFID](https://img.shields.io/badge/NFC%2FRFID-Authentication-yellow)
![Research](https://img.shields.io/badge/Project-Final%20Year%20Research-success)

</p>

---

## 📌 Project Overview

The **Sustainable Bike Sharing System with Smart Tracking and Docking** is a one-year final-year research project developed as a **low-cost, IoT-enabled bicycle-sharing platform** for universities, campuses and small urban environments.

The system combines embedded electronics, GPS tracking, inertial sensing, cellular communication, MQTT, user authentication and smart docking into a single bicycle-sharing platform.

The project focuses on developing a practical and affordable alternative to large-scale commercial bike-sharing infrastructure.

### Main implemented technologies

* 🚲 Smart bicycle sharing
* 📍 GPS-based bicycle tracking
* 🧭 IMU-based movement sensing
* 📡 4G LTE cellular communication
* 📬 MQTT-based IoT communication
* 🔐 NFC-based authentication
* 🅿️ Smart docking
* 🔒 Solenoid-based locking mechanism
* 🔋 Rechargeable battery system
* ☀️ Solar charging subsystem
* 📱 Mobile application
* ☁️ IoT/cloud backend
* 🧩 Custom PCB development
* 🖨️ 3D-printed mechanical components

---

# 🎯 Research Objective

The main objective of this research is to develop and evaluate a **low-cost smart bicycle-sharing system** that can provide secure bicycle access, real-time tracking and intelligent docking without requiring expensive commercial infrastructure.

The research investigates the integration of:

```text
Embedded Systems
       +
GPS Tracking
       +
IMU Sensing
       +
4G LTE
       +
MQTT
       +
NFC Authentication
       +
Smart Docking
       +
Solar Charging
       +
Mobile Application
```

into a unified bicycle-sharing platform.

---

# 🌍 Target Application

The proposed system is primarily designed for:

* Universities
* University campuses
* Small cities
* Private campuses
* Research institutions
* Controlled bicycle-sharing environments

The system is particularly suitable for environments where a **low-cost and decentralized bike-sharing solution** is preferred.

---

# ✨ Main Features

| Feature                 | Description                                                               |
| ----------------------- | ------------------------------------------------------------------------- |
| 📍 GPS Tracking         | Determines the geographic location of the bicycle                         |
| 🧭 IMU Sensing          | Detects bicycle movement and provides inertial data                       |
| 📡 4G LTE Communication | Provides cellular connectivity for remote communication                   |
| 📬 MQTT Communication   | Transfers tracking and system data through an MQTT-based IoT architecture |
| 🔐 NFC Authentication   | Provides user identification and authentication                           |
| 🅿️ Smart Docking       | Detects and manages bicycle docking                                       |
| 🔒 Electronic Locking   | Solenoid-based bicycle locking mechanism                                  |
| 🔋 Battery System       | Provides portable power for the bicycle electronics                       |
| ☀️ Solar Charging       | Provides supplementary charging capability                                |
| 📱 Mobile Application   | Provides the user interface for the bike-sharing system                   |
| ☁️ IoT Backend          | Receives and manages bicycle/system data                                  |
| 🧩 Custom PCB           | Provides integrated electronic hardware                                   |
| 🖨️ 3D-Printed Parts    | Provides customized mechanical structures and enclosures                  |

---

# 🏗️ System Architecture

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
                                    │
                                    ▼
                         ┌─────────────────────┐
                         │   IoT / MQTT        │
                         │      Backend        │
                         │                     │
                         │ MQTT Broker         │
                         │ Database / Server   │
                         └──────────┬──────────┘
                                    │
                              MQTT over 4G
                                    │
                                    ▼
                  ┌────────────────────────────────┐
                  │       Bicycle Tracking Unit    │
                  │                                │
                  │             ESP32              │
                  │                                │
                  │   ┌────────┐   ┌──────────┐   │
                  │   │  GPS   │   │   IMU    │   │
                  │   └────────┘   └──────────┘   │
                  │                                │
                  │   ┌────────────────────────┐   │
                  │   │ Air780E 4G LTE Module   │   │
                  │   └────────────────────────┘   │
                  │                                │
                  │   ┌──────────┐ ┌───────────┐ │
                  │   │ Battery  │ │ Solar     │ │
                  │   │ System   │ │ Charging  │ │
                  │   └──────────┘ └───────────┘ │
                  └────────────────┬───────────────┘
                                   │
                                   │
                                   ▼
                         ┌─────────────────────┐
                         │ Smart Docking Unit  │
                         │                     │
                         │ NFC Authentication │
                         │ Solenoid Lock       │
                         │ Relay / Driver     │
                         │ Docking Mechanism  │
                         └─────────────────────┘
```

---

# 🚲 Bike Tracking System

The bike tracking subsystem is responsible for monitoring the bicycle's location and movement and transmitting the collected information to the IoT backend.

## Main Hardware

* ESP32 Development Board
* NEO-6M GPS Module
* NEO-8M GPS Module
* Air780E 4G LTE Module
* SIM800L GSM Module
* ICM-20948 IMU
* MPU9250 IMU
* GPS antenna
* 4G/cellular antenna
* Rechargeable battery pack
* 3S BMS
* LM2596 buck converters
* Custom PCB

---

# 📍 GPS Tracking

GPS is used to determine the bicycle's geographic position.

The project evaluated different GPS modules during development, including:

### NEO-6M

Used as a low-cost GPS option for prototype development and testing.

### NEO-8M

Evaluated as an improved GPS receiver for comparison and positioning-performance testing.

The comparison allowed the project to investigate the practical differences between GPS receiver modules under real operating conditions.

---

# 🧭 IMU-Based Movement Detection

The tracking system also incorporates inertial measurement units.

The project tested:

* **ICM-20948**
* **MPU9250**

The IMU provides motion-related measurements that can be used to determine bicycle movement and support the tracking subsystem.

The system can use sensor information to distinguish between conditions such as:

```text
Bicycle Stationary
       │
       ▼
Movement Detected
       │
       ▼
GPS / IMU Data Collection
       │
       ▼
Tracking Data Processing
       │
       ▼
MQTT Transmission
```

---

# 📡 4G LTE Communication

The primary cellular communication module used for the IoT tracking system is the:

### Air780E 4G LTE Module

The Air780E provides cellular connectivity between the bicycle and the remote IoT infrastructure.

The communication path is:

```text
ESP32
  │
  │ UART
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

This allows the bicycle to transmit data without depending on local Wi-Fi infrastructure.

---

# 📬 MQTT Communication

The final IoT communication architecture uses **MQTT**.

MQTT was selected because it is lightweight and suitable for IoT systems where devices need to exchange relatively small amounts of data over wireless networks.

### Basic communication structure

```text
Bicycle ESP32
      │
      ▼
Air780E 4G LTE
      │
      ▼
Internet
      │
      ▼
MQTT Broker
      │
      ├──────────► Backend
      │
      └──────────► Mobile Application
```

The bicycle acts as an MQTT client and publishes relevant system information through MQTT topics.

---

# 🔐 NFC Authentication

NFC is used as part of the bicycle authentication system.

The system includes:

* NFC reader
* NFC card
* ESP32 controller

Basic operation:

```text
User
 │
 ▼
NFC Card
 │
 ▼
NFC Reader
 │
 ▼
ESP32
 │
 ├── Valid ──► Allow Bicycle Operation
 │
 └── Invalid ─► Reject Access
```

This provides a simple physical authentication mechanism for the bike-sharing system.

---

# 🅿️ Smart Docking and Locking

The docking subsystem is responsible for securing the bicycle when it is returned to the docking station.

The prototype includes:

* ESP32 controllers
* Solenoid locks
* Relay/driver modules
* NFC readers
* NFC cards
* Buzzers
* Custom PCB
* 3D-printed mechanical parts
* Mechanical components
* Welding/fabrication work

### Basic docking process

```text
Bicycle Arrives
      │
      ▼
Dock Detection
      │
      ▼
Authentication
      │
      ▼
Locking Mechanism
      │
      ▼
Bicycle Secured
      │
      ▼
System Status Updated
```

---

# 🔋 Battery System

The tracking system uses a rechargeable battery configuration.

The prototype uses:

* 3 × 18650 Li-ion cells
* 3.7 V nominal cell voltage
* 3200 mAh rated capacity per cell
* 3S BMS / HW-288
* LM2596 buck converters

The general power architecture is:

```text
3 × 18650 Battery
        │
        ▼
     3S BMS
        │
        ▼
 Main Power Rail
        │
        ├────► ESP32
        │
        ├────► GPS
        │
        ├────► Air780E
        │
        └────► IMU / Other Electronics
```

---

# ☀️ Solar Charging System

A small solar charging subsystem was developed as part of the prototype.

The subsystem includes:

* Small 5 V / 30 mA solar panels
* 3S BMS / HW-288
* Fuse
* LM2596 buck converter

The solar subsystem provides supplementary charging capability for the battery system.

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
Battery Storage
```

---

# 🧩 Custom PCB Development

Custom PCBs were developed to move the project from breadboard-level prototyping toward a more integrated hardware implementation.

PCB development included:

* Circuit integration
* Component placement
* Power distribution
* Sensor connections
* Communication interfaces
* Connector selection
* Prototype testing

The PCB files can be found in:

```text
hardware/pcb/
```

---

# 🖨️ 3D-Printed Mechanical Development

3D printing was used to develop customized mechanical components and enclosures.

The workflow included:

```text
3D Modelling
     ↓
Mechanical Design
     ↓
Prototype Printing
     ↓
Assembly
     ↓
Testing
     ↓
Design Modification
```

3D-printed parts were used to support the physical integration of electronic components and the docking system.

---

# 📱 Mobile Application

The mobile application acts as the user-facing interface of the bicycle-sharing platform.

The application is intended to provide functions such as:

* User interaction
* Bicycle information
* Bicycle availability
* Tracking information
* Authentication
* Ride-related information
* System status

The application communicates with the IoT/backend infrastructure rather than requiring direct communication with every hardware component.

---

# ☁️ IoT Backend

The backend receives and manages information transmitted from the bicycle.

The general data flow is:

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

The backend can manage information related to:

* Bicycle identity
* User information
* Location
* Movement status
* Ride information
* Docking status
* System events

---

# 🧪 Research Methodology

The project was developed over a one-year research period using an iterative engineering approach.

```text
Literature Review
       ↓
Problem Identification
       ↓
System Requirements
       ↓
Conceptual Design
       ↓
Component Selection
       ↓
Individual Module Testing
       ↓
Subsystem Development
       ↓
Prototype Integration
       ↓
PCB Development
       ↓
Mechanical Integration
       ↓
System Testing
       ↓
Performance Evaluation
       ↓
Final Prototype
```

---

# 🧪 Testing and Evaluation

The project involved testing individual components and integrated subsystems.

### Tracking Tests

* GPS positioning
* NEO-6M evaluation
* NEO-8M evaluation
* GPS antenna performance
* IMU measurements
* Movement detection
* Cellular connectivity
* MQTT communication

### Power Tests

* Battery voltage
* Battery current consumption
* BMS operation
* Buck converter operation
* Solar charging subsystem

### Docking Tests

* NFC authentication
* Solenoid lock operation
* Relay/driver operation
* Docking mechanism
* Mechanical operation

### System-Level Tests

* Tracking communication
* MQTT data transmission
* Mobile/backend interaction
* Bicycle docking
* Authentication
* Overall prototype operation

---

# 📊 Hardware Bill of Materials

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
| **Tracking Subtotal**          |       |                  | **LKR 27,567** |

---

## B. Bike Locking / Docking System

| Component                        |   Qty | Unit Price (LKR) |    Total (LKR) |
| -------------------------------- | ----: | ---------------: | -------------: |
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
| **Locking/Docking Subtotal**     |       |                  | **LKR 32,800** |

---

## C. Solar Charging System

| Component                       | Qty | Unit Price (LKR) |   Total (LKR) |
| ------------------------------- | --: | ---------------: | ------------: |
| 3S BMS / HW-288                 |   1 |             500* |           500 |
| Fuse                            |   1 |              40* |            40 |
| LM2596 Buck Converter           |   1 |             220* |           220 |
| Small Solar Panel – 5 V / 30 mA |   2 |              350 |           700 |
| **Solar Charging Subtotal**     |     |                  | **LKR 1,460** |

---

## D. 3D Printing / Enclosure

| Component                                      |   Qty |   Total (LKR) |
| ---------------------------------------------- | ----: | ------------: |
| 3D Printing Filament / Material for Enclosures | 1 lot |         5,500 |
| **3D Printing Subtotal**                       |       | **LKR 5,500** |

---

# 💰 Final Project Budget

| Section                          | Cost (LKR) |
| -------------------------------- | ---------: |
| A. Bike Tracking System          |     27,567 |
| B. Bike Locking / Docking System |     32,800 |
| C. Solar Charging System         |      1,460 |
| D. 3D Printing / Enclosure       |      5,500 |
| **Overall Project Cost**         | **67,327** |

> `*` Approximate/local prototype cost.

---

# 🧰 Development Tools

### Firmware

* C/C++
* Arduino IDE
* ESP32 development environment

### Hardware

* PCB design tools
* Electronic test equipment
* Breadboard prototyping
* Custom PCB fabrication

### Mechanical

* Blender
* Bambu Studio
* 3D printing
* PLA filament

### Communication

* 4G LTE
* MQTT
* UART
* I²C
* SPI

### Software

* Mobile application development tools
* Backend/API development tools
* Database technologies
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
│   ├── docking/
│   └── solar_monitoring/
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
└── README.md
```

---

# ⚠️ Current Limitations

As a research prototype, several areas remain open for further development:

* GPS accuracy depends on environmental conditions.
* IMU-based positioning can accumulate error over time.
* Cellular communication depends on network availability.
* Solar charging output is limited by panel size and environmental conditions.
* Prototype mechanical components require further durability testing.
* Large-scale deployment requires additional testing and infrastructure.
* Long-term battery performance requires extended field evaluation.

---

# 🔮 Future Developments

The following features are **not claimed as completed features of the current prototype** and are proposed for future research and development.

## ⚡ 1. Advanced Energy Harvesting

Future work can investigate more efficient methods of harvesting mechanical energy from bicycle operation.

Potential sources include:

* Bicycle dynamo systems
* Piezoelectric energy harvesting
* Improved power conditioning
* Energy storage optimization

---

## 🔌 2. Advanced Energy Transfer

Future development can investigate more efficient methods for transferring harvested energy between the bicycle and docking infrastructure.

Possible approaches include:

* Improved electrical transfer interfaces
* Automated charging contacts
* Contactless energy transfer
* Dock-based charging optimization

---

## 🧠 3. Advanced Tracking

Future research can improve positioning accuracy using:

* Advanced GPS/GNSS receivers
* Sensor fusion
* Improved dead reckoning
* Kalman filtering
* RTK positioning
* Better map matching

---

## 🔋 4. Intelligent Battery Management

Future versions could include more advanced battery monitoring and predictive battery-health estimation.

Potential features include:

* Individual cell monitoring
* State-of-charge estimation
* State-of-health estimation
* Battery fault detection
* Predictive maintenance

---

## 🌐 5. Large-Scale IoT Deployment

Future work can investigate:

* Multiple bicycle fleets
* Multiple docking stations
* Centralized fleet management
* Real-time analytics
* Remote diagnostics
* Scalable MQTT architecture

---

## 📱 6. Improved Mobile Application

Future application development could include:

* Real-time map tracking
* Bicycle reservation
* Ride history
* Usage analytics
* Notifications
* User account management
* Fleet availability visualization

---

# 🎓 Research Contribution

This research demonstrates the feasibility of integrating several technologies into a **low-cost smart bicycle-sharing prototype**.

The key contribution is the integration of:

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
Battery System
 +
Solar Charging
 +
Mobile Application
 +
IoT Backend
```

into a unified platform.

The project provides a foundation for further research into **sustainable, decentralized and intelligent bicycle-sharing systems**.

---

# 👥 Academic Project

**Project Type:** Final Year Research Project
**Duration:** One Academic Year
**Degree:** Bachelor of Science Honours in Electronics and Computer Science
**University:** University of Kelaniya

### Research Project

> **Sustainable Bike Sharing System with Energy Harvesting, Transfer and Smart Docking**

---

# 📜 License

This repository contains academic research and prototype implementation developed as part of a university final-year research project.

The appropriate license should be selected based on the requirements of the project team and university.

---

# 🙏 Acknowledgements

We acknowledge the support and guidance provided by:

* University of Kelaniya
* Academic supervisors
* Department staff
* Laboratory staff
* Project collaborators
* Individuals and organizations who supported the development and testing of the prototype

---

# 🚲 Project Summary

The **Sustainable Bike Sharing System** is a low-cost IoT-based bicycle-sharing research platform integrating:

**GPS Tracking + IMU Sensing + 4G LTE + MQTT + NFC Authentication + Smart Docking + Battery Management + Solar Charging + Mobile Application + IoT Backend**

The prototype demonstrates how embedded electronics, wireless communication, sensing, software and mechanical engineering can be combined to develop a practical smart mobility solution for universities and small urban environments.

Future research will focus on improving **energy harvesting, energy transfer, positioning accuracy, battery intelligence and large-scale deployment**.

<p align="center">

### 🚲 Smart Mobility • 📍 Intelligent Tracking • 📡 IoT • 🔐 Secure Access • ☀️ Sustainable Technology

</p>
