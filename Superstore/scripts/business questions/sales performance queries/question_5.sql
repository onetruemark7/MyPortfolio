-- Sales Performances Questions --
-- Which regions produce the highest sales?

select
    dr.region as region,
    sum(fo.sales) as total_revenue
from gold.fact_order fo
join gold.dim_region dr
    on fo.region_id = dr.region_id
group by dr.region
order by total_revenue desc
limit 1;