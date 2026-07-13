-- Profitability Questions --
-- Which shipping methods reduce profitability?

select
    dsm.ship_mode as ship_mode,
    round(sum(profit),2) as total_profit
from gold.fact_order fo
join gold.dim_ship_mode dsm
    on fo.ship_mode_id = dsm.ship_mode_id
group by
    dsm.ship_mode
order by total_profit asc
limit 1;