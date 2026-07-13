-- Customer Analysis Question --
-- Which regions have the highest customer concentration?

select
    dr.region as region,
    count(fo.region_id) as total_orders
from gold.fact_order fo
join gold.dim_region dr
    on fo.region_id = dr.region_id
group by dr.region
order by total_orders desc
limit 5;