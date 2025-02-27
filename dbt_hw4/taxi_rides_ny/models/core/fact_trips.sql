{{ config(materialized='table') }}

WITH green_trips AS (
    SELECT
        'Green' AS service_type,
        pickup_datetime,
        dropoff_datetime,
        pickup_locationid AS pickup_location_id,
        dropoff_locationid AS dropoff_location_id,
        fare_amount,
        total_amount
    FROM {{ ref('stg_green_tripdata') }}
),
yellow_trips AS (
    SELECT
        'Yellow' AS service_type,
        pickup_datetime,
        dropoff_datetime,
        pickup_locationid AS pickup_location_id,
        dropoff_locationid AS dropoff_location_id,
        fare_amount,
        total_amount
    FROM {{ ref('stg_yellow_tripdata') }}
),
all_trips AS (
    SELECT * FROM green_trips
    UNION ALL
    SELECT * FROM yellow_trips
)

SELECT
    t.service_type,
    t.pickup_datetime,
    t.dropoff_datetime,
    t.pickup_location_id,
    pz.Zone AS pickup_zone,
    pz.Borough AS pickup_borough,
    t.dropoff_location_id,
    dz.Zone AS dropoff_zone,
    dz.Borough AS dropoff_borough,
    t.fare_amount,
    t.total_amount
FROM all_trips t
LEFT JOIN {{ source('taxi_data', 'dim_zones') }} pz
    ON t.pickup_location_id = pz.LocationID
LEFT JOIN {{ source('taxi_data', 'dim_zones') }} dz
    ON t.dropoff_location_id = dz.LocationID