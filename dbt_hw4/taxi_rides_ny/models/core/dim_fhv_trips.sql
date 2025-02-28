{{ config(materialized='table') }}

SELECT
    dispatching_base_num,
    pickup_datetime,
    dropOff_datetime,
    PUlocationID AS pickup_location_id,
    pz.Zone AS pickup_zone,
    pz.Borough AS pickup_borough,
    DOlocationID AS dropoff_location_id,
    dz.Zone AS dropoff_zone,
    dz.Borough AS dropoff_borough,
    SR_Flag,
    Affiliated_base_number,
    EXTRACT(YEAR FROM pickup_datetime) AS year,
    EXTRACT(MONTH FROM pickup_datetime) AS month
FROM {{ ref('stg_fhv_tripdata') }}
LEFT JOIN {{ source('taxi_data', 'dim_zones') }} pz
    ON PUlocationID = pz.LocationID
LEFT JOIN {{ source('taxi_data', 'dim_zones') }} dz
    ON DOlocationID = dz.LocationID