/*
  Device Lifecycle Funnel
  -----------------------
  Computes device counts across lifecycle stages:
  - Tagged
  - Dealer App Registered
  - Platform Linked
  - Subscribed
  - Pinged in last 7 days

  Used for funnel visualization and conversion analysis.
*/

WITH tagged_devices AS (
    SELECT
        d.id AS device_id,
        inst.sts AS dealer_app_sts,
        iot.next_recharge_due_at,
        ld.time_stamp AS last_ping
    FROM devices_device d
    LEFT JOIN iotmis_device iot
        ON d.id = iot.device_id
    LEFT JOIN amk_dealership_deviceinstallationmaster inst
        ON d.id = inst.device_fk_id
    LEFT JOIN devices_devicelatestdata ld
        ON ld.device_fk_id = d.id
    WHERE
        (iot.is_test_device IS FALSE OR iot.is_test_device IS NULL)
        AND 'ent_industrial_fleet' = ANY(d.device_tags)
)

SELECT 'Tagged Devices' AS step, COUNT(DISTINCT device_id) AS value
FROM tagged_devices

UNION ALL
SELECT 'Dealer App Registered Devices', COUNT(DISTINCT device_id)
FROM tagged_devices
WHERE dealer_app_sts IS NOT NULL

UNION ALL
SELECT 'Platform Linked Devices', COUNT(DISTINCT device_id)
FROM tagged_devices
WHERE dealer_app_sts IS NOT NULL

UNION ALL
SELECT 'Subscribed Devices', COUNT(DISTINCT device_id)
FROM tagged_devices
WHERE next_recharge_due_at >= CURRENT_DATE

UNION ALL
SELECT 'Pinged in Last 7 Days', COUNT(DISTINCT device_id)
FROM tagged_devices
WHERE last_ping >= NOW() - INTERVAL '7 days';
