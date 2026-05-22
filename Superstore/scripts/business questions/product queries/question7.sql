-- Product Analysis Question --
-- Which sub-categories have the highest profit margins?

select
    dsc.sub_category as sub_category,
    sum(fo.sales) as total_sales,
    sum(profit) as total_profit,
    round(sum(profit) * 100 / sum(fo.sales),2) as profit_margin
from gold.fact_order fo
join gold.dim_sub_category dsc
    on fo.sub_category_id = dsc.sub_category_id
group by dsc.sub_category
order by profit_margin desc
limit 5;