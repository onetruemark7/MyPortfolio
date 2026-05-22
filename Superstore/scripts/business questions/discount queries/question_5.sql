-- Discount Analysis Question
-- Are discounts overused in specific regions?

with used_discount_per_region as (
    select
        dr.region,
        fo.discount,
        sum(fo.sales) as total_sales,
        sum(fo.profit) as total_profit,
        round(sum(fo.profit) *100 / sum(fo.sales),2) as profit_margin_pct,
        count(fo.order_id) as number_order,
        sum(fo.discount) as total_discount
    from gold.fact_orders fo
    join gold.dim_region dr
        on fo.region_id = dr.region_id
    group by
        dr.region,
        fo.discount
)

select
    region,
    discount,
    total_sales,
    total_profit,
    profit_margin_pct,
    number_order,
    total_discount
from used_discount_per_region
where total_profit < 0 and profit_margin_pct < 0;  -- indication of overused discounts