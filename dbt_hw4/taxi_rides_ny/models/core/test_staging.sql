SELECT DISTINCT EXTRACT(YEAR FROM pickup_datetime) AS year
FROM {{ ref('stg_green_tripdata') }}
UNION DISTINCT
SELECT DISTINCT EXTRACT(YEAR FROM pickup_datetime) AS year
FROM {{ ref('stg_yellow_tripdata') }}
ORDER BY year
