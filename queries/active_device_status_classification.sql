/*
  Active Device Status Classification
  ----------------------------------
  Classifies devices into:
  - Active (pinged in last 7 days)
  - Active but not pinged recently
  - Not installed
*/

WITH base_devices AS (
    SELECT id AS device_id
    FROM devices_device
    WHERE 'ent_industrial_fleet' = ANY(device_tags)
),

latest_activation AS (
    SELECT DISTINCT ON (device_id)
        device_id,
        is_primary_info_stage_completed,
        is_tractor_test_stage_completed,
        is_final_test_passed
    FROM amk_dealership_deviceactivationinfo
    ORDER BY device_id, sts DESC
),

latest_ping AS (
    SELECT
        device_fk_id AS device_id,
        sts AS last_ping_utc
    FROM devices_devicelatestdata
)

SELECT
    CASE
        WHEN
            la.is_primary_info_stage_completed
            AND la.is_tractor_test_stage_completed
            AND la.is_final_test_passed
            AND lp.last_ping_utc >= NOW() - INTERVAL '7 days'
        THEN 'Active (Ping < 7 Days)'

        WHEN
            la.is_primary_info_stage_completed
            AND la.is_tractor_test_stage_completed
            AND la.is_final_test_passed
        THEN 'Active but Not Pinged Recently'

        ELSE 'Not Installed'
    END AS device_status,
    COUNT(*) AS device_count
FROM base_devices b
LEFT JOIN latest_activation la ON la.device_id = b.device_id
LEFT JOIN latest_ping lp ON lp.device_id = b.device_id
GROUP BY device_status
ORDER BY device_status;
