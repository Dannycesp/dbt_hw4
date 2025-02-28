{{ config(materialized='table') }}

-- Compute base quarterly revenue per service type
WITH base_revenue AS (
  SELECT
    service_type,
    EXTRACT(YEAR FROM pickup_datetime) AS year,
    EXTRACT(QUARTER FROM pickup_datetime) AS quarter,
    SUM(total_amount) AS revenue  -- Renamed to 'revenue' to avoid naming conflicts
  FROM `dtc-de-course-449200.dbt_dcesp.fact_trips`
  GROUP BY service_type, year, quarter
),

-- Calculate the previous year's revenue for the same quarter using LAG window function
revenue_with_prev AS (
  SELECT
    service_type,
    year,
    quarter,
    revenue,
    LAG(revenue) OVER (
      PARTITION BY service_type, quarter  -- Compare same quarters across years
      ORDER BY year                      -- Get the previous year's revenue
    ) AS prev_revenue
  FROM base_revenue
  WHERE year IN (2019, 2020)  -- Restrict to the years relevant for YoY comparison
)

-- Final query: Calculate the YoY growth percentage for 2020
SELECT
  service_type,
  year,
  quarter,
  revenue,
  ROUND(100.0 * (revenue - prev_revenue) / prev_revenue, 2) AS yoy_growth_percentage
FROM revenue_with_prev
WHERE year = 2020  -- Focus on 2020 data for YoY analysis
ORDER BY service_type, quarter
