-- Shipping and Logistic Question
-- Which states have inefficient shipping performance?

with shipping_perf as (
    select
        ds.state,
        sum(fo.shipping_cost) as total_shipping_cost,
        avg(fo.shipping_cost) as average_shipping_cost,
        count(*) as total_order
    from gold.fact_orders fo
    join gold.dim_state ds
        on fo.state_id = ds.state_id
    group by ds.state
    order by total_shipping_cost
    limit 50
)
, delivery_time_per_state as (
    select
        ds.state,
        abs(extract(day from fo.order_date - fo.ship_date)) as delivery_time_in_day
    from gold.fact_orders fo
    join gold.dim_state ds
        on fo.state_id = ds.state_id
)
, avg_delivery as (
    select
        state,
        avg(delivery_time_in_day) as average_delivery_time_in_day
    from delivery_time_per_state
    group by state
)

select
    sp.state,
    round(ad.average_delivery_time_in_day,2) as average_delivery_time_in_day,
    sp.total_order,
    sp.total_shipping_cost,
    round(sp.average_shipping_cost,2) as average_shipping_cost
from shipping_perf sp
join avg_delivery ad
    on sp.state = ad.state
order by total_order, total_shipping_cost, average_shipping_cost
limit 50;