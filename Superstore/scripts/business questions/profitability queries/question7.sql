-- Profitability Questions --
-- Which customer segments are the most profitable?

select
    ds.segment as segment,
    round(sum(fo.profit),2) as total_profit
from gold.fact_order fo
join gold.dim_segment ds
    on fo.segment_id = ds.segment_id
group by ds.segment
order by total_profit desc
limit 1;