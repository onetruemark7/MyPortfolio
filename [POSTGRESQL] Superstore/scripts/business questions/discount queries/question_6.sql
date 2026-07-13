-- Discount Analysis Question
-- Which customer segments respond best to discounts?

with overall_calc as (
    select
        ds.segment,
        discount,
        sum(fo.sales) as total_sales,
        sum(fo.profit) as total_profit,
        round(sum(fo.profit) * 100 / sum(fo.sales),2) as profit_margin_pct
    from gold.fact_orders fo
    join gold.dim_segment ds
        on fo.segment_id = ds.segment_id
    group by
        ds.segment, discount
)

select
    segment,
    discount,
    total_sales,
    round(total_profit,2) as total_profit,
    profit_margin_pct
from overall_calc
where total_profit > 0 and profit_margin_pct > 0