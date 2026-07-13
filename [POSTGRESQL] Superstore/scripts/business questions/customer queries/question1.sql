-- Customer Analysis Question --
-- Who are the highest-value customers?

select
    dc.first_name|| ' ' || dc.last_name as customer_name,
    sum(fo.sales) as total_sales
from gold.fact_order fo
join gold.dim_customer dc
    on fo.customer_id = dc.customer_id
group by dc.first_name|| ' ' || dc.last_name
order by total_sales desc
limit 1;