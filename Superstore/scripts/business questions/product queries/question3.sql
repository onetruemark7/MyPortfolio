-- Product Analysis Question --
-- Which products are commonly discounted?

    select
        dp.product_name as product_name,
        sum(fo.profit) as total_profit,
        sum(fo.sales) as total_sales,
        count(fo.discount) discount_times
    from gold.fact_order fo
    join gold.dim_product dp
        on fo.product_id = dp.product_id
    group by dp.product_name
    order by discount_times desc
    limit 100;