-- Product Analysis Question --
-- Which products have strong sales but weak profitability?

select
    dp.product_name as product_name,
    sum(sales) as total_sales,
    sum(profit) as total_profit
from gold.fact_order fo
join gold.dim_product dp
    on fo.product_id = dp.product_id
group by dp.product_name
having
     sum(sales) > 5000 and -- threshold for strong sales
     sum(profit) < 100 -- threshold for weak profitability
order by total_sales desc;