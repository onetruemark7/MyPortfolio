-- Customer Analysis Question --
-- Which customers are associated with repeated losses?

select
    dc.customer_id,
    sum(fo.profit) as total_profit
from gold.fact_order fo
join gold.dim_customer dc
    on fo.customer_id = dc.customer_id
group by dc.customer_id
having sum(fo.profit) < 0
order by total_profit
