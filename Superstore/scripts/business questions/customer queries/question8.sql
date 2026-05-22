-- Customer Analysis Question --
-- Which customer segments are most sensitive to discounts?

select
    ds.segment as customer_segment,
    CASE
        WHEN fo.discount = 0 THEN 'No Discount'
        WHEN fo.discount <= 0.15 THEN 'Low Discount (0-15%)'
        WHEN fo.discount <= 0.30 THEN 'Medium Discount (15-30%)'
        ELSE 'High Discount (30%+)'
    END AS discount_level,
    round(avg(fo.discount),2)as average_discount,
    sum(fo.sales) as total_sales,
    sum(fo.profit) as total_profit,
    count(*) as total_transactions,
    round((sum(fo.profit) / nullif(sum(fo.sales),0))*100,2) as profit_margin_pct,
    round(avg(fo.quantity),2) as average_quantity
from gold.fact_order fo
join gold.dim_segment ds
    on fo.segment_id = ds.segment_id
group by
    ds.segment,
    CASE
        WHEN fo.discount = 0 THEN 'No Discount'
        WHEN fo.discount <= 0.15 THEN 'Low Discount (0-15%)'
        WHEN fo.discount <= 0.30 THEN 'Medium Discount (15-30%)'
        ELSE 'High Discount (30%+)'
    END
order by average_discount desc, total_sales desc