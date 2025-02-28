# Homework 4

## Question 1. Model resolution (1 point)

- ( ) select * from dtc_zoomcamp_2025.raw_nyc_tripdata.ext_green_taxi  
- ( ) select * from dtc_zoomcamp_2025.my_nyc_tripdata.ext_green_taxi  
- (**x**) select * from myproject.raw_nyc_tripdata.ext_green_taxi  
- ( ) select * from myproject.my_nyc_tripdata.ext_green_taxi  
- ( ) select * from dtc_zoomcamp_2025.raw_nyc_tripdata.green_taxi  

---

## Question 2. Change the query (1 point)

- ( ) Add ORDER BY pickup_datetime DESC and LIMIT {{ var("days_back", 30) }}  
- ( ) Update the WHERE clause to pickup_datetime >= CURRENT_DATE - INTERVAL '{{ var("days_back", 30) }}' DAY  
- ( ) Update the WHERE clause to pickup_datetime >= CURRENT_DATE - INTERVAL '{{ env_var("DAYS_BACK", "30") }}' DAY  
- (**x**) Update the WHERE clause to pickup_datetime >= CURRENT_DATE - INTERVAL '{{ var("days_back", env_var("DAYS_BACK", "30")) }}' DAY  
- ( ) Update the WHERE clause to pickup_datetime >= CURRENT_DATE - INTERVAL '{{ env_var("DAYS_BACK", var("days_back", "30")) }}' DAY  

---

## Question 3. Lineage (1 point)

- ( ) dbt run  
- ( ) dbt run --select +models/core/dim_taxi_trips.sql+ --target prod  
- ( ) dbt run --select +models/core/fct_taxi_monthly_zone_revenue.sql  
- ( ) dbt run --select +models/core/  
- (**x**) dbt run --select models/staging/+  

---

## Question 4. Macros and Jinja (1 point)

- [x] Setting a value for DBT_BIGQUERY_TARGET_DATASET env var is mandatory, or it'll fail to compile  
- [ ] Setting a value for DBT_BIGQUERY_STAGING_DATASET env var is mandatory, or it'll fail to compile  
- [x] When using core, it materializes in the dataset defined in DBT_BIGQUERY_TARGET_DATASET  
- [x] When using stg, it materializes in the dataset defined in DBT_BIGQUERY_STAGING_DATASET, or defaults to DBT_BIGQUERY_TARGET_DATASET  
- [x] When using staging, it materializes in the dataset defined in DBT_BIGQUERY_STAGING_DATASET, or defaults to DBT_BIGQUERY_TARGET_DATASET  

---

## Question 5. Taxi Quarterly Revenue Growth (1 point)

1. (**x**) green: {best: 2020/Q2, worst: 2020/Q1}, yellow: {best: 2020/Q2, worst: 2020/Q1}  
2. ( ) green: {best: 2020/Q2, worst: 2020/Q1}, yellow: {best: 2020/Q3, worst: 2020/Q4}  
3. ( ) green: {best: 2020/Q1, worst: 2020/Q2}, yellow: {best: 2020/Q2, worst: 2020/Q1}  
4. ( ) green: {best: 2020/Q1, worst: 2020/Q2}, yellow: {best: 2020/Q1, worst: 2020/Q2}  
5. ( ) green: {best: 2020/Q1, worst: 2020/Q2}, yellow: {best: 2020/Q3, worst: 2020/Q4}  

---

## Question 6. P97/P95/P90 Taxi Monthly Fare (1 point)

1. (**x**) green: {p97: 55.0, p95: 45.0, p90: 26.5}, yellow: {p97: 52.0, p95: 37.0, p90: 25.5}  
2. ( ) green: {p97: 55.0, p95: 45.0, p90: 26.5}, yellow: {p97: 31.5, p95: 25.5, p90: 19.0}  
3. ( ) green: {p97: 40.0, p95: 33.0, p90: 24.5}, yellow: {p97: 52.0, p95: 37.0, p90: 25.5}  
4. ( ) green: {p97: 40.0, p95: 33.0, p90: 24.5}, yellow: {p97: 31.5, p95: 25.5, p90: 19.0}  
5. ( ) green: {p97: 55.0, p95: 45.0, p90: 26.5}, yellow: {p97: 52.0, p95: 25.5, p90: 19.0}  

---

## Question 7. Top #Nth longest P90 travel time Location for FHV (2 points)

1. (**x**) LaGuardia Airport, Chinatown, Garment District  
2. ( ) LaGuardia Airport, Park Slope, Clinton East  
3. ( ) LaGuardia Airport, Saint Albans, Howard Beach  
4. ( ) LaGuardia Airport, Rosedale, Bath Beach  
5. ( ) LaGuardia Airport, Yorkville East, Greenpoint  
