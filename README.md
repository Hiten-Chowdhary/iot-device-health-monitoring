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
Active (Ping < 7 Days) ██████████████████████████████ 60.6%

Not Installed / Never Pinged ██████████ 21.2%

Active but No Fuel Data ████████ 18.2%

Classifies devices based on recent connectivity to provide a high-level fleet
health overview.

### Device Health Distribution (ASCII Representation)

### Summary Table

| Status Category             | Percentage | Device Count |
|----------------------------|------------|--------------|
| Active (Ping < 7 Days)     | 60.6%      | 40           |
| Not Installed              | 21.2%      | 14           |
| Active but No Fuel Data    | 18.2%      | 12           |
| **Total**                  | **100%**   | **66**       |

---

## 4. Device Lifecycle Funnel Analysis

Tracks the progression of devices across key onboarding and operational stages,
helping identify drop-offs and inefficiencies in the device lifecycle.

### Funnel Visualization (ASCII)

Tagged Devices ██████████████████████████████ 66

Dealer App Registered ████████████████████████ 52 (78.8%)

KSK / Platform Linked ████████████████████████ 52 (78.8%)

Subscribed Devices ████████████████████████ 52 (78.8%)

Pinged in Last 7 Days ███████████████████ 40 (60.6%)

### Key Observations
- Major drop observed post tagging during dealer registration
- Subscription conversion remains stable after linking
- Connectivity issues account for final funnel drop

---

## 5. Productivity – Day-wise Analysis

Measures fleet productivity by comparing:
- Kilometers covered (kms)
- Engine running hours (engine_hrs)
- Fleet-level utilization patterns

### Sample Output

| Fleet Number | Kilometers (kms) | Engine Hours |
|--------------|------------------|--------------|
| MH03         | 210.4            | 22.1         |
| VTR24        | 228.7            | 15.3         |
| LT12         | 115.6            | 4.2          |
| VTR39        | 205.9            | 14.8         |

---

## 6. Servicing Due Estimates

Estimates upcoming servicing requirements using cumulative engine hours and
average daily usage to predict service dates.

### Sample Output

| Device ID | Engine Hours | Avg Hrs / Active Day | Service Due At | Hrs Remaining | Est. Days to Service | Est. Service Date |
|----------:|--------------|----------------------|----------------|---------------|----------------------|-------------------|
| 252086    | 400.97       | 14.85                | 500            | 99.03         | 7                    | 31 Dec 2025       |
| 252072    | 353.49       | 13.09                | 500            | 146.51        | 11                   | 04 Jan 2026       |
| 252121    | 265.44       | 12.64                | 500            | 234.56        | 19                   | 12 Jan 2026       |

---

## Tools & Technologies
- SQL (PostgreSQL)
- Metabase (dashboards & visualization)
- Relational IoT data models

---

## Key Takeaways
- Demonstrates production-grade SQL for IoT operations
- Covers full device lifecycle from installation to servicing
- Combines monitoring, analytics, and operational insights
- Designed for scalability and real-world industrial use cases

---

## Disclaimer
All outputs and identifiers shown are anonymized and representative.
This repository does not expose proprietary systems, internal identifiers,
or sensitive production data.


