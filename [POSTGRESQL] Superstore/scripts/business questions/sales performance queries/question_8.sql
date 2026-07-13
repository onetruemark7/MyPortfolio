-- Sales Performances Questions --
-- What are the peak sales seasons or months?

select
    date_trunc('month', order_date)::date as date_month,
    to_char(date_trunc('month', order_date), 'Month') as month_name,
    sum(sales) as total_revenue
from gold.fact_order
group by date_trunc('month', order_date)
order by total_revenue desc
limit 4;