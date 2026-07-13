-- Product Analysis Question --
-- Which products have the highest average order value?

    select
        dp.product_name as product_name,
        round(avg(sales),2) as average_sale
    from gold.fact_order fo
    join gold.dim_product dp
        on fo.product_id = dp.product_id
    group by dp.product_name
    order by average_sale desc
    limit 100;