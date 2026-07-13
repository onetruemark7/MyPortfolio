-- Profitability Questions --
-- Which products generate the highest profit?

select
    dp.product_name as product_name,
    round(sum(fo.profit),2)  as total_revene
from gold.fact_order fo
join gold.dim_product dp
    on fo.product_id = dp.product_id
group by dp.product_name
order by total_revene desc
limit 1;