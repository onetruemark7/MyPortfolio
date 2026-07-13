-- Product Analysis Question --
-- Which products should receive more inventory investment?
with monthly_kpi as (
    select
        date_trunc('month',fo.order_date) as date_month,
        dp.product_name as product_name,
        sum(fo.sales) as total_sales,
        sum(fo.profit) as total_profit,
        count(*) as total_orders,
        sum(fo.profit) * 100 / nullif(sum(fo.sales),0) as profit_margin_pct
    from gold.fact_order fo
    join gold.dim_product dp
        on fo.product_id = dp.product_id
    group by
        date_trunc('month',fo.order_date),
        dp.product_name
)
, inventory_remarks as (
    select
        date_month::date as date,
        product_name,
        total_profit,
        total_sales,
        total_orders,
        round(profit_margin_pct,2) as profit_margin_pct,

        case
            when total_profit > 100 then 'Needs Inventory Investment'
            else 'Needs Inventory Review'
        end as remarks

    from monthly_kpi
    order by  total_profit desc, total_orders desc, profit_margin_pct desc
)

select
    *
from inventory_remarks
where remarks = 'Needs Inventory Investment'