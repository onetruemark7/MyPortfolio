-- Profitability Questions --
-- Which states or cities have negative profit margins?

select
    ds.state as state,
    sum(fo.profit) as total_profit
from gold.fact_order fo
join gold.dim_state ds
    on fo.state_id = ds.state_id
group by ds.state
having sum(fo.profit) < 0;