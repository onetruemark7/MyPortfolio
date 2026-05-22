-- Product Analysis Question --
-- Which product categories have declining sales trends?

with sales_summary as (
    select
        date_trunc('year', order_date) as date_year,
        dc.category as category,
        sum(sales) as total_sales
    from gold.fact_order fo
    join gold.dim_category dc
        on fo.category_id = dc.category_id
    group by date_trunc('year', order_date), dc.category
)
, yoy_calc as (
    select
        date_year,
        category,
        total_sales,
        coalesce(
        round(((total_sales - lag(total_sales,1) over (partition by category order by date_year)) /
            lag(total_sales,1) over (partition by category order by date_year))*100,2) || '%','N/A') as YoY_pct
    from sales_summary
)

select
    *,
    case
    when lag(YoY_pct,1) over (partition by category order by date_year) = 'N/A' then 'Increasing Sales'
    when YoY_pct = 'N/A' then 'Calculating'
    when YoY_pct < lag(YoY_pct,1) over (partition by category order by date_year) then 'Decreasing Sales'
    else 'Increasing Sales'
    end as remarks
from yoy_calc