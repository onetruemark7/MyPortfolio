-- Sales Performances Questions --
-- Which sub-categories contribute the most revenue?

select
    dsc.sub_category as sub_category,
    sum(fo.sales) as total_revenue
from gold.fact_order fo
join gold.dim_sub_category dsc
    on fo.sub_category_id = dsc.sub_category_id
group by  dsc.sub_category
order by  total_revenue desc;