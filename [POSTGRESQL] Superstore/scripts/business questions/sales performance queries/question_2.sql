-- Sales Performances Questions --
-- Which product categories generate the highest sales?

select
    dc.category as product_category,
    sum(fo.sales) as total_revenue
from gold.fact_order fo
join gold.dim_category dc
    on fo.category_id = dc.category_id
group by dc.category
order by total_revenue desc;