/*
  Productivity & Driving Behavior – Day-wise
  ------------------------------------------
  Combines:
  - Distance & engine hours
  - Overspeeding events
  - Harsh driving episodes
*/

WITH base_devices AS (
    SELECT id AS device_id
    FROM devices_device
    WHERE 'ent_industrial_fleet' = ANY(device_tags)
),

daily_util AS (
    SELECT
        dd.day,
        dd.device_fk_id AS device_id,
        tm.metadata->>'fleet_number' AS fleet_number,
        dd.total_distance / 1000.0 AS kms,
        EXTRACT(EPOCH FROM dd.running_time) / 3600.0 AS engine_hrs
    FROM data_day dd
    JOIN base_devices bd ON bd.device_id = dd.device_fk_id
    LEFT JOIN tractor_metadata tm ON tm.device_id = dd.device_fk_id
    WHERE dd.day >= CURRENT_DATE - INTERVAL '1 day'
),

overspeed AS (
    SELECT
        device_fk_id AS device_id,
        day,
        COUNT(*) AS overspeed_events,
        MAX(max_speed) AS max_speed
    FROM data_overspeed_events
    WHERE day >= CURRENT_DATE - INTERVAL '1 day'
    GROUP BY device_fk_id, day
),

green_events AS (
    SELECT
        device_fk_id AS device_id,
        day,
        COUNT(*) AS harsh_events
    FROM data_green_driving_events
    WHERE day >= CURRENT_DATE - INTERVAL '1 day'
    GROUP BY device_fk_id, day
)

SELECT
    u.day,
    u.device_id,
    u.fleet_number,
    u.kms,
    u.engine_hrs,
    COALESCE(o.overspeed_events, 0) AS overspeed_events,
    o.max_speed,
    COALESCE(g.harsh_events, 0) AS harsh_events
FROM daily_util u
LEFT JOIN overspeed o ON o.device_id = u.device_id AND o.day = u.day
LEFT JOIN green_events g ON g.device_id = u.device_id AND g.day = u.day
ORDER BY u.day DESC, u.device_id;
