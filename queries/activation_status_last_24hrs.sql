/*
  Activation Status – Day-wise (Last 24 Hours)
  --------------------------------------------
  This query identifies IoT devices that have been activated in the last 24 hours
  and evaluates installation health based on completion stages and linked data.

  Installation Health Logic:
  - Properly Installed:
      • Primary info stage completed
      • Tractor test stage completed
      • Final test passed
      • Tractor linked
      • Customer phone available
  - Not Properly Installed:
      • Any of the above conditions not met

  Notes:
  - Tag names and identifiers are anonymized for portfolio use
  - Designed for PostgreSQL-compatible databases
*/

WITH latest_records AS (
    -- Fetch latest activation record per device within last 24 hours
    SELECT
        adi.device_id,
        MAX(adi.sts) AS latest_sts
    FROM amk_dealership_deviceactivationinfo adi
    JOIN devices_device d
        ON d.id = adi.device_id
    WHERE
        adi.sts >= NOW() - INTERVAL '24 hours'
        AND 'ent_industrial_fleet' = ANY(d.device_tags)
    GROUP BY
        adi.device_id
)

SELECT
    adi.id AS activation_id,
    adi.device_id,
    d.passcode,
    u.phone AS customer_phone,
    tt.id AS tractor_id,
    adi.is_primary_info_stage_completed,
    adi.is_tractor_test_stage_completed,
    adi.is_final_test_passed,

    -- Installation health classification
    CASE
        WHEN u.phone IS NULL
             OR tt.id IS NULL
            THEN 'Not Properly Installed'

        WHEN adi.is_primary_info_stage_completed = TRUE
         AND adi.is_tractor_test_stage_completed = TRUE
         AND adi.is_final_test_passed = TRUE
            THEN 'Properly Installed'

        ELSE 'Not Properly Installed'
    END AS installation_health,

    -- Activation timestamp in IST
    adi.sts AT TIME ZONE 'UTC' AT TIME ZONE 'Asia/Kolkata' AS activation_time_ist,

    adi.state,
    adi.district

FROM amk_dealership_deviceactivationinfo adi
JOIN latest_records lr
    ON adi.device_id = lr.device_id
   AND adi.sts = lr.latest_sts
LEFT JOIN tractor_tractor tt
    ON tt.device_id = adi.device_id
LEFT JOIN devices_device d
    ON d.id = adi.device_id
LEFT JOIN users_userprofile u
    ON u.id = tt.user_id
WHERE
    'ent_industrial_fleet' = ANY(d.device_tags)
ORDER BY
    adi.sts DESC;
