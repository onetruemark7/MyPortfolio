-- Sales Performances Questions --
-- Which shipping modes are associated with the highest sales?

select
    dsm.ship_mode as ship_mode,
    sum(fo.sales) as total_revene
from gold.fact_order fo
join gold.dim_ship_mode dsm
    on fo.ship_mode_id = dsm.ship_mode_id
group by dsm.ship_mode
order by total_revene desc
limit 1;