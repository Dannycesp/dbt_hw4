{{ config(materialized='table') }}

SELECT
    service_type,
    EXTRACT(YEAR FROM pickup_datetime) AS year,
    EXTRACT(MONTH FROM pickup_datetime) AS month,
    PERCENTILE_CONT(fare_amount, 0.97) OVER (PARTITION BY service_type, EXTRACT(YEAR FROM pickup_datetime), EXTRACT(MONTH FROM pickup_datetime)) AS p97_fare_amount,
    PERCENTILE_CONT(fare_amount, 0.95) OVER (PARTITION BY service_type, EXTRACT(YEAR FROM pickup_datetime), EXTRACT(MONTH FROM pickup_datetime)) AS p95_fare_amount,
    PERCENTILE_CONT(fare_amount, 0.90) OVER (PARTITION BY service_type, EXTRACT(YEAR FROM pickup_datetime), EXTRACT(MONTH FROM pickup_datetime)) AS p90_fare_amount
FROM {{ ref('fact_trips') }}
WHERE
    fare_amount > 0
    AND trip_distance > 0
    AND payment_type IN (1, 2)
    AND pickup_datetime BETWEEN '2020-04-01' AND '2020-04-30'