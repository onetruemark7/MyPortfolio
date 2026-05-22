-- Profitability Questions --
-- Which regions are most profitable?

select
    dr.region as region,
    round(sum(fo.profit),2) as total_profit
from gold.fact_order fo
join gold.dim_region dr
    on fo.region_id = dr.region_id
group by dr.region
order by total_profit desc
limit 1;