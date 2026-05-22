-- Discount Analysis Question
-- How do discounts affect profitability?

select
    discount || ' - ' || round(100 * discount,2) || '%' as discount,
    round(sum(profit),2) as total_profit
from gold.fact_orders
group by
    discount || ' - ' || round(100 * discount,2) || '%'
order by total_profit desc
limit 1;