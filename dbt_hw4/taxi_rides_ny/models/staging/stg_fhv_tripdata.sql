{{ config(materialized='view') }}

SELECT
    dispatching_base_num,
    pickup_datetime,
    dropOff_datetime,
    PUlocationID,
    DOlocationID,
    SR_Flag,
    Affiliated_base_number
FROM {{ source('taxi_data', 'fhv_taxi_ext') }}
WHERE dispatching_base_num IS NOT NULL