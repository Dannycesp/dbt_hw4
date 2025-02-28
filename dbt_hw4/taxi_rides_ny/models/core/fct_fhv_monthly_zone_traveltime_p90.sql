WITH trip_durations AS (
    SELECT
        d.year,
        d.month,
        d.pickup_location_id,
        d.dropoff_location_id,
        pz.Zone AS pickup_zone,
        dz.Zone AS dropoff_zone,
        TIMESTAMP_DIFF(d.dropOff_datetime, d.pickup_datetime, SECOND) AS trip_duration
    FROM `dtc-de-course-449200`.`dbt_dcesp`.`dim_fhv_trips` d
    LEFT JOIN `dtc-de-course-449200`.`taxi_data`.`dim_zones` pz
        ON d.pickup_location_id = pz.LocationID
    LEFT JOIN `dtc-de-course-449200`.`taxi_data`.`dim_zones` dz
        ON d.dropoff_location_id = dz.LocationID
    WHERE
        d.pickup_datetime BETWEEN '2019-11-01' AND '2019-11-30'
        AND d.dropOff_datetime IS NOT NULL
),
p90_by_zone AS (
    SELECT
        pickup_zone,
        dropoff_zone,
        PERCENTILE_CONT(trip_duration, 0.90) OVER (
            PARTITION BY pickup_zone, dropoff_zone
        ) AS p90_trip_duration
    FROM trip_durations
    WHERE pickup_zone IN ('Newark Airport', 'SoHo', 'Yorkville East')
),
distinct_p90 AS (
    SELECT DISTINCT
        pickup_zone,
        dropoff_zone,
        p90_trip_duration
    FROM p90_by_zone
)

SELECT
    pickup_zone,
    dropoff_zone,
    p90_trip_duration,
    ROW_NUMBER() OVER (
        PARTITION BY pickup_zone
        ORDER BY p90_trip_duration DESC
    ) AS rank
FROM distinct_p90
ORDER BY pickup_zone, rank
LIMIT 15