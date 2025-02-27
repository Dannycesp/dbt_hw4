{{ config(materialized='table') }}

WITH quarterly_revenue AS (
    SELECT
        service_type,
        EXTRACT(YEAR FROM pickup_datetime) AS year,
        EXTRACT(QUARTER FROM pickup_datetime) AS quarter,
        SUM(total_amount) AS quarterly_revenue
    FROM {{ ref('fact_trips') }}
    GROUP BY service_type, year, quarter
),
revenue_with_yoy AS (
    SELECT
        service_type,
        year,
        quarter,
        quarterly_revenue,
        LAG(quarterly_revenue) OVER (
            PARTITION BY service_type, quarter
            ORDER BY year
        ) AS prev_year_revenue,
        ROUND(
            100.0 * (quarterly_revenue - LAG(quarterly_revenue) OVER (
                PARTITION BY service_type, quarter
                ORDER BY year
            )) / LAG(quarterly_revenue) OVER (
                PARTITION BY service_type, quarter
                ORDER BY year
            ), 2
        ) AS yoy_growth_percentage
    FROM quarterly_revenue
    WHERE year IN (2019, 2020)
)

SELECT
    service_type,
    year,
    quarter,
    quarterly_revenue,
    yoy_growth_percentage
FROM revenue_with_yoy
WHERE year = 2020
ORDER BY service_type, quarter