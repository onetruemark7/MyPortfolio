-- Customer Analysis Question --
-- Which customers contribute most to total profit?

select
    dc.first_name|| ' ' || dc.last_name as customer_name,
    round(sum(fo.profit),2) as total_profit
from gold.fact_order fo
join gold.dim_customer dc
    on fo.customer_id = dc.customer_id
group by dc.first_name, dc.last_name
order by total_profit desc
limit 30;