-- Sales Performances Questions --
-- Which customer segments generate the most sales?

select
    ds.segment as segment,
    sum(fo.sales) as total_revenue
from gold.fact_order fo
join gold.dim_segment ds
    on fo.segment_id = ds.segment_id
group by
    ds.segment
order by total_revenue desc
limit 1; 