/*
  Device Health & Fuel Status
  --------------------------
  Provides operational visibility using:
  - Battery voltage
  - Last ping (IST)
  - Fuel availability
*/

WITH devices AS (
    SELECT id AS device_id
    FROM devices_device
    WHERE 'ent_industrial_fleet' = ANY(device_tags)
),

device_core AS (
    SELECT
        d.device_id,
        ld.sts AS last_ping_utc,
        ld.battery_voltage,
        ld.fuel_level_dashboard,
        tm.metadata->>'fleet_number' AS fleet_number,
        ttm.manufacturer,
        ttm.model
    FROM devices d
    LEFT JOIN devices_devicelatestdata ld ON ld.device_fk_id = d.device_id
    LEFT JOIN tractor_tractor tt ON tt.device_id = d.device_id
    LEFT JOIN tractor_tractormodel ttm ON tt.model_id = ttm.id
    LEFT JOIN tractor_metadata tm ON tm.device_id = d.device_id
)

SELECT
    device_id,
    COALESCE(fleet_number, 'No Fleet Assigned') AS fleet_number,
    manufacturer,
    model,
    battery_voltage,
    TO_CHAR(last_ping_utc AT TIME ZONE 'UTC' AT TIME ZONE 'Asia/Kolkata','YYYY-MM-DD') AS last_ping_date,
    TO_CHAR(last_ping_utc AT TIME ZONE 'UTC' AT TIME ZONE 'Asia/Kolkata','HH24:MI:SS') AS last_ping_time_ist,
    ROUND(EXTRACT(EPOCH FROM (NOW() - last_ping_utc))/3600,2) AS hours_since_last_ping,
    fuel_level_dashboard,
    CASE
        WHEN fuel_level_dashboard = 0 THEN 'Fuel Level Zero'
        WHEN fuel_level_dashboard IS NULL THEN 'No Fuel Data'
        ELSE 'Fuel Data Available'
    END AS fuel_status,
    CASE
        WHEN last_ping_utc >= NOW() - INTERVAL '7 days' THEN 'Active (Ping < 7 Days)'
        ELSE 'Not Pinged in Last 7 Days'
    END AS device_status
FROM device_core
ORDER BY last_ping_utc DESC NULLS LAST;
