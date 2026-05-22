-- Shipping and Logistic Question
-- Is there a relationship between shipping mode and customer segment?

with overall_summary as (
        select
            dsm.ship_mode,
            ds.segment,
            sum(fo.sales) as total_sales,
            sum(fo.profit) as total_profit,
            sum(fo.profit) * 100 / sum(fo.sales) as profit_margin_pct,
            avg(fo.sales) as average_sales,
            avg(fo.profit) as average_profit,
            count(*) as total_transaction
        from gold.fact_orders fo
        join gold.dim_segment ds
            on fo.segment_id = ds.segment_id
        join gold.dim_ship_mode dsm
            on fo.ship_mode_id = dsm.ship_mode_id
        group by dsm.ship_mode, ds.segment
)

select
    ship_mode,
    segment,
    total_sales,
    round(total_profit,2) as total_profit,
    round(average_sales,2) as average_sales,
    round(average_profit,2) as average_profit,
    total_transaction,
    round(profit_margin_pct,2) || '%' as profit_margin_pct,
    round((total_transaction * 100 / sum(total_transaction) over()),2) || '%' as total_transaction_pct
from overall_summary
order by total_profit desc ;