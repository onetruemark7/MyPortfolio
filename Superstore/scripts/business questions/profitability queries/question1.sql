-- Profitability Questions --
-- Which categories are the most profitable?

select
   dc.category as category,
   round( sum(fo.profit),2)  as total_revene
from gold.fact_order fo
join gold.dim_category dc
    on fo.category_id = dc.category_id
group by dc.category
order by total_revene desc
limit 1;