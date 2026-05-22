-- Discount Analysis Question
-- Which states suffer losses due to excessive discounts?

select
    ds.state,
    discount,
    sum(profit) as total_profits
from gold.fact_orders fo
join gold.dim_state ds
    on fo.state_id = ds.state_id
group by ds.state, discount
having
    discount > 0.25 and -- threshold or hard discount starts at 25% and negative on profit side
    sum(profit) < 0
order by total_profits asc ;