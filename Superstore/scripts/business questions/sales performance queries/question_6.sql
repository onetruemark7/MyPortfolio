-- Sales Performances Questions --
-- Which states or cities contribute the most revenue?

select
    ds.state as state,
    sum(fo.sales) as total_revenue
from gold.fact_order fo
join gold.dim_state ds
    on fo.state_id = ds.state_id
    group by ds.state
    order by total_revenue desc
    limit 1;