-- Customer Analysis Question --
-- Which customers purchase most frequently?

select
    dc.first_name|| ' ' || dc.last_name as customer_name,
    count(dc.customer_id) as total_orders
from gold.fact_order fo
join gold.dim_customer dc
    on fo.customer_id = dc.customer_id
group by dc.first_name|| ' ' || dc.last_name
order by total_orders desc
limit 10;