-- Shipping and Logistic Question
-- Which shipping mode has the fastest delivery time?

select
    dsm.ship_mode,
    abs(extract(day from fo.order_date - fo.ship_date)) as delivery_time
from gold.fact_orders fo
join gold.dim_ship_mode dsm
    on fo.ship_mode_id = dsm.ship_mode_id
order by  delivery_time asc
limit 1;