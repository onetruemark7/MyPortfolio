WITH monthly_sales AS (
    SELECT
        product_id,
        EXTRACT(MONTH FROM order_date) AS month,
        SUM(sales) AS total_sales,
        COUNT(*) AS num_transactions
    FROM gold.fact_order
    GROUP BY product_id, EXTRACT(MONTH FROM order_date)
),
product_stats AS (
    SELECT
        product_id,
        SUM(total_sales) AS annual_sales,
        COUNT(DISTINCT month) AS months_active,
        MAX(total_sales) AS peak_month_sales,
        AVG(total_sales) AS avg_monthly_sales,
        STDDEV(total_sales) AS sales_stddev,
        (MAX(total_sales) * 1.0 / SUM(total_sales)) AS peak_concentration
    FROM monthly_sales
    GROUP BY product_id
    HAVING SUM(total_sales) > 1000  -- Filter for meaningful volume
)
SELECT
    dp.product_name,
    p.annual_sales,
    p.months_active,
    p.peak_concentration,
    p.avg_monthly_sales,
    p.sales_stddev,
    MAX(m.month) AS peak_month  -- Example peak month
FROM product_stats p
JOIN monthly_sales m ON p.product_id = m.product_id
    AND m.total_sales = p.peak_month_sales
join gold.dim_product dp
    on p.product_id = dp.product_id
WHERE p.peak_concentration > 0.4  -- High concentration in 1-2 months, or adjust threshold
   OR p.sales_stddev / NULLIF(p.avg_monthly_sales, 0) > 1.0  -- High coefficient of variation
group by
    dp.product_name,
    p.annual_sales,
    p.months_active,
    p.peak_concentration,
    p.avg_monthly_sales,
    p.sales_stddev
ORDER BY p.peak_concentration DESC, p.annual_sales DESC
LIMIT 50;