-- Product Analysis Question --
-- Which products are most frequently ordered?

select
    dp.product_name as product_name,
    count(fo.order_id) as total_order
from gold.fact_order fo
join gold.dim_product dp
    on fo.product_id = dp.product_id
group by dp.product_name
order by total_order desc
limit 30;