{{ config(materialized='table') }}

WITH filtered_trips AS (
    SELECT
        service_type,
        pickup_datetime,
        fare_amount,
        trip_distance,
        payment_type
    FROM `dtc-de-course-449200`.`dbt_dcesp`.`fact_trips`
    WHERE
        fare_amount > 0
        AND trip_distance > 0
        AND payment_type IN (1, 2)  -- Credit Card, Cash
),
percentiles AS (
    SELECT
        service_type,
        EXTRACT(YEAR FROM pickup_datetime) AS year,
        EXTRACT(MONTH FROM pickup_datetime) AS month,
        PERCENTILE_CONT(fare_amount, 0.97) OVER (PARTITION BY service_type, EXTRACT(YEAR FROM pickup_datetime), EXTRACT(MONTH FROM pickup_datetime)) AS p97_fare_amount,
        PERCENTILE_CONT(fare_amount, 0.95) OVER (PARTITION BY service_type, EXTRACT(YEAR FROM pickup_datetime), EXTRACT(MONTH FROM pickup_datetime)) AS p95_fare_amount,
        PERCENTILE_CONT(fare_amount, 0.90) OVER (PARTITION BY service_type, EXTRACT(YEAR FROM pickup_datetime), EXTRACT(MONTH FROM pickup_datetime)) AS p90_fare_amount
    FROM filtered_trips
)

SELECT DISTINCT
    service_type,
    year,
    month,
    p97_fare_amount,
    p95_fare_amount,
    p90_fare_amount
FROM percentiles
ORDER BY service_type, year, month