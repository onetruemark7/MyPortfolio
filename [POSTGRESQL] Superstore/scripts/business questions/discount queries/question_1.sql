-- Discount Analysis Question
-- How do discounts affect sales volume?

select
    discount || ' - ' || round(100 * discount,2) || '%' as discount,
    sum(sales) as total_revenue,
    round(avg(sales),2) as average_revenue,
    round(avg(quantity),2)  as average_quantity
from gold.fact_orders
group by
    discount || ' - ' || round(100 * discount,2) || '%'
order by total_revenue desc