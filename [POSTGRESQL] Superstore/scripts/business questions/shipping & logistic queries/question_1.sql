-- Shipping and Logistic Question
-- Which shipping mode is used most frequently?

select
    dsm.ship_mode,
    count(*) as total_transaction
from gold.fact_orders fo
join gold.dim_ship_mode dsm
    on fo.ship_mode_id = dsm.ship_mode_id
group by dsm.ship_mode
order by total_transaction desc
limit 1;