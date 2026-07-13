with product_region_perf as (
    select
        dp.product_name,
        dr.region,
        sum(fo.sales) AS total_sales,
        sum(fo.profit) AS total_profit,
        sum(fo.quantity) AS total_quantity,
        COUNT(*) AS order_count,
        ROUND(SUM(fo.profit) * 100.0 / NULLIF(sum(fo.sales), 0), 2) AS profit_margin_pct
    from gold.fact_order fo
    join gold.dim_region dr
        on fo.region_id = dr.region_id
    join gold.dim_product dp
        on fo.product_id = dp.product_id
    group by dr.region, dp.product_name
),
product_stats AS (
    select
        product_name,
        count(DISTINCT region) AS num_regions,
        sum(total_sales) AS global_sales,
        sum(total_profit) AS global_profit,
        stddev_samp(profit_margin_pct) AS margin_stddev,           -- Key variance measure
        max(profit_margin_pct) - min(profit_margin_pct) AS margin_range
    from product_region_perf
    group by product_name
    having count(DISTINCT region) >= 3 AND sum(total_sales) > 5000   -- Filter noise
)
select
    p.product_name,
    p.num_regions,
    p.global_sales,
    p.global_profit,
    ROUND(p.margin_stddev, 2) AS margin_stddev,
    ROUND(p.margin_range, 2) AS margin_range,
    pr.region,
    pr.total_sales,
    pr.profit_margin_pct
from product_stats p
join product_region_perf pr ON p.product_name = pr.product_name
where p.margin_stddev is not null
order by p.margin_stddev desc, p.global_sales desc
limit 100;