-- Exploratory Data Analysis(EDA) process for Category

select
    --date_trunc('year',order_date) as order_date, -- remove comment to show annual KPI
    --date_trunc('quarter',order_date) as order_date, -- remove comment to show quarterly KPI
    --date_trunc('month',order_date) as order_date, -- remove comment to show monthly KPI
    --date_trunc('week',order_date) as order_date, -- remove comment to show weekly KPI
    dc.category,
    sum(sales) total_revenue,
    max(sales) maximum_sales,
    min(sales) minimum_sales,
    round(avg(sales),2)  average_revenue,
    count(*)  number_of_orders,

    sum(profit) total_profit,
    max(profit) maximum_profit,
    min(profit) minimum_profit,
    round(avg(profit),2)  average_profit,

    sum(quantity) units_sold,
    max(quantity) maximum_units_sold,
    min(quantity) minimum_units_sold,
    round(avg(quantity),2)  average_units_sold
from gold.fact_order fo
join gold.dim_category dc
    on fo.category_id = dc.category_id
group by
    dc.category;