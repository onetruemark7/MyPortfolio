-- Shipping and Logistic Question
-- Which product categories require expedited shipping most often?

select
    dc.category,
    dsm.ship_mode,
    count(*) as total_transaction
from gold.fact_orders fo
join gold.dim_category dc
    on fo.category_id = dc.category_id
join gold.dim_ship_mode dsm
    on fo.ship_mode_id = dsm.ship_mode_id
where dsm.ship_mode = 'First Class'
group by dc.category, dsm.ship_mode
order by total_transaction desc
limit 1;