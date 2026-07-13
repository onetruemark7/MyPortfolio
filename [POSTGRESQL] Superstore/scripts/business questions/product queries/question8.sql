-- Product Analysis Question --
-- Which products should potentially be discontinued?

with overall_summary as (
    select
        dp.product_name as product_name,
        sum(fo.sales) as total_sales,
        sum(fo.profit) as total_profit,
        count(*) as number_of_orders,
        avg(discount) as average_discount,
        sum(fo.profit) * 100.00 / sum(fo.sales) as profit_margin_pct
    from gold.fact_order fo
    join gold.dim_product dp
        on fo.product_id = dp.product_id
    group by dp.product_name
)
, product_remarks as (
    select
    product_name,
    total_sales,
    total_profit,
    number_of_orders,
    round(average_discount,2) as average_discount,
    round(profit_margin_pct,2) as profit_margin_pct,

    case
        when total_profit < 0 then 'Unprofitable'
        else 'Profitable'
    end as profitability,

    case
        when number_of_orders < 50 then 'Rarely sold'
        else 'Regular'
    end as order_frequency,

    case
        when profit_margin_pct < 3 then 'Low Margin'
        else 'Good Margin'
    end margin_tier
from overall_summary
)

select *
from product_remarks
where profitability = 'Unprofitable'
order by profit_margin_pct
