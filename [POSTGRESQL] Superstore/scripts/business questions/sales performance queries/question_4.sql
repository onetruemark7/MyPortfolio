-- Sales Performances Questions --
-- Which products are the top-selling items?

select
    dp.product_name as product_name,
    sum(fo.sales) as total_revenue
from gold.fact_order fo
join gold.dim_product dp
    on fo.product_id = dp.product_id
group by  dp.product_name
order by total_revenue desc;