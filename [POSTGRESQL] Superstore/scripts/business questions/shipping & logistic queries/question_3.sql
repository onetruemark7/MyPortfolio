-- Shipping and Logistic Question
-- Does faster shipping increase profitability?

select
     abs(extract(day from order_date - ship_date)) as delivery_time_by_days,
     round(sum(profit),2) as total_profit
from gold.fact_orders
group by abs(extract(day from order_date - ship_date))
order by total_profit desc