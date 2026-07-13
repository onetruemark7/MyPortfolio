-- Profitability Questions --
-- Which products consistently generate losses?

select
    dp.product_name as product_name,
    round(sum(fo.profit),2)  as total_revenue
from gold.fact_order fo
join gold.dim_product dp
    on fo.product_id = dp.product_id
group by dp.product_name
having sum(fo.profit) < 0
order by total_revenue asc;