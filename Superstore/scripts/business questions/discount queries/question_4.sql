-- Discount Analysis Question
-- Which products receive the highest discounts?

select
    dp.product_name,
    fo.discount || ' (' || 100*discount|| '%)' as discount,
    sum(sales) as total_sales,
    sum(fo.profit)  as total_profit,
    count(*) as number_of_orders
from gold.fact_orders fo
join gold.dim_product dp
    on fo.product_id = dp.product_id
group by
    dp.product_name,
    fo.discount
order by discount desc
limit 100;