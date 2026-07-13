-- Customer Analysis Question --
-- What is the customer retention trend over time?

WITH customer_first_year AS (
    -- Find the first year each customer purchased
    SELECT
        customer_id,
        MIN(date_trunc('year', order_date)) AS cohort_year
    FROM gold.fact_order
    GROUP BY customer_id
),
cohort_retention AS (
    SELECT
        cf.cohort_year,
        date_trunc('year', fo.order_date) AS year,
        COUNT(DISTINCT fo.customer_id) AS active_customers
    FROM gold.fact_order fo
    JOIN customer_first_year cf
        ON fo.customer_id = cf.customer_id
    GROUP BY
        cf.cohort_year,
        date_trunc('year', fo.order_date)
)
SELECT
    cohort_year,
    year,
    active_customers,
    -- Retention Rate % compared to the original cohort size
    ROUND(
        100.0 * active_customers
        / FIRST_VALUE(active_customers) OVER (PARTITION BY cohort_year ORDER BY year)
    , 2) AS retention_rate_pct,
    (year - cohort_year) AS years_since_first_purchase
FROM cohort_retention
ORDER BY cohort_year, years_since_first_purchase;