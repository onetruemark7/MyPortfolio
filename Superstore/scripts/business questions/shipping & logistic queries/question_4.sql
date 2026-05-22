-- Shipping and Logistic Question
-- What is the average shipping delay per region?

select
    dr.region,
    avg(abs(extract(days from fo.order_date - fo.ship_date))) as average_shipping
from gold.fact_orders fo
join gold.dim_region dr
    on fo.region_id = dr.region_id
group by dr.region ;