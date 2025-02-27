{{ config(materialized='table') }}

WITH trip_durations AS (
    SELECT
        year,
        month,
        pickup_location_id,
        dropoff_location_id,
        dropoff_zone,
        TIMESTAMP_DIFF(dropOff_datetime, pickup_datetime, SECOND) AS trip_duration
    FROM {{ ref('dim_fhv_trips') }}
    WHERE
        pickup_datetime BETWEEN '2019-11-01' AND '2019-11-30'
        AND dropOff_datetime IS NOT NULL
)

SELECT
    pickup_zone,
    dropoff_zone,
    PERCENTILE_CONT(trip_duration, 0.90) OVER (
        PARTITION BY year, month, pickup_location_id, dropoff_location_id
    ) AS p90_trip_duration
FROM trip_durations
JOIN {{ source('taxi_data', 'dim_zones') }} pz
    ON trip_durations.pickup_location_id = pz.LocationID
WHERE
    pickup_zone IN ('Newark Airport', 'SoHo', 'Yorkville East')
QUALIFY ROW_NUMBER() OVER (
    PARTITION BY pickup_zone
    ORDER BY p90_trip_duration DESC
) = 2