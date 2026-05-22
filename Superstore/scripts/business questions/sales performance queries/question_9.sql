-- Sales Performances Questions --
-- How does sales performance compare year-over-year?

with annual_revenue as (
    select
        extract(year from order_date) as date_year,
        sum(sales) as total_revenue
    from gold.fact_order
    group by extract(year from order_date)
)

select
    date_year,
    total_revenue,
    lag(total_revenue,1) over (order by total_revenue) as prev_total_revenue,
    round(
        (
            (total_revenue - lag(total_revenue,1) over (order by total_revenue)) /
            lag(total_revenue,1) over (order by total_revenue)
        )*100
    ,2) || '%' as YoY_pct
from annual_revenue
