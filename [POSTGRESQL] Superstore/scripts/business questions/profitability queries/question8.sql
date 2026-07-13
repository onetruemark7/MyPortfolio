-- Profitability Questions --
-- Which orders have high sales but low profit?

with agg_revenue_profit as (
        select
        order_id,
        sum(sales) as total_sales,
        sum(profit) as total_profit
    from gold.fact_order
    group by order_id
    having
        sum(sales) > 0 and
        sum(profit) > 0
)

select
    order_id,
    percentile_cont(0.8) within group ( order by total_sales ) as high_sales,
    percentile_cont(0.3) within group ( order by total_profit desc ) as low_profit
from agg_revenue_profit
group by
    order_id,
    total_sales,
    total_profit
having
    percentile_cont(0.8) within group ( order by total_sales ) > 1000 and --threshold for high sales
    percentile_cont(0.3) within group ( order by total_profit desc ) < 100 --threshold for low profit
order by high_sales desc, low_profit desc