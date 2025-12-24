# SQL Industrial IoT Device Monitoring & Operations Analytics

## Overview
This repository contains a collection of production-style SQL queries designed
to monitor, analyze, and track the operational health, productivity, and lifecycle
of large-scale industrial IoT fleets.

The project focuses on real-world operations use cases such as device activation,
connectivity monitoring, fuel data availability, productivity measurement, servicing
estimation, and device onboarding funnels. All datasets and outputs shown are
anonymized and representative.

---

## Key Objectives
- Monitor device installation and activation status in near real time
- Track device connectivity and health based on last ping data
- Identify non-pinging, never-installed, and healthy devices
- Measure daily productivity using distance and engine-hour metrics
- Estimate servicing schedules based on usage
- Analyze device lifecycle drop-offs using funnel logic

---

## 1. Activation Status – Day-wise (Last 24 Hours)

Tracks device installation and activation events recorded during field deployment.
This helps operations teams validate installations and identify pending or delayed
activations.

### Sample Output

| Device ID | Activation Date | Activation Time | Installation Status |
|----------:|-----------------|-----------------|---------------------|
| 252120    | 2025-12-24      | 03:21:38        | Installed           |
| 252091    | 2025-12-24      | 03:19:38        | Installed           |
| 252086    | 2025-12-24      | 03:15:24        | Installed           |

---

## 2. Device Health & Fuel Status (Operational View)

Provides a consolidated operational snapshot per device, including:
- Battery voltage
- Last ping date & time (IST)
- Hours since last ping
- Fuel level and fuel data availability
- Overall device health classification

### Sample Output

| Device ID | Fleet Number | Manufacturer | Model | Battery Voltage | Last Ping Date | Last Ping Time (IST) | Hours Since Last Ping | Fuel Level | Fuel Status         | Device Status          |
|----------:|--------------|--------------|-------|-----------------|---------------|----------------------|-----------------------|------------|---------------------|------------------------|
| 252095    | CS01         | Case IH      | JX45T | 12849           | 2025-12-24    | 03:08:30             | 0.26                  | 4.9        | Fuel Data Available | Active (Ping < 7 Days) |
| 252113    | CS11         | New Holland  | 3630 | 14445           | 2025-12-24    | 03:06:00             | 0.30                  | 63.33      | Fuel Data Available | Active (Ping < 7 Days) |
| 252086    | VTR24        | Valtra       | 193  | 14425           | 2025-12-24    | 03:15:24             | 0.14                  | 0          | Fuel Level Zero     | Active (Ping < 7 Days) |

---

## 3. Active Device Status – 7 Day Health Classification (Pie)

Classifies devices based on recent connectivity to provide a high-level fleet
health overview.

### Device Health Distribution (ASCII Representation)

