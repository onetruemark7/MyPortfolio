-- Sales Performances Questions --
-- What are the total sales over time (daily, monthly, quarterly, yearly)?

select
    --extract(day from order_date) as date_by_day,
    --extract(month from order_date) as date_by_day,
    --extract(quarter from order_date) as date_by_day,
    extract(year from order_date) as date_by_day,
    sum(sales) as total_revenue
from gold.fact_order
group by extract(year from order_date);