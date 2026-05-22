-- Discount Analysis Question
-- Which categories remain profitable despite high discounts?

select
    dc.category,
    discount,
    sum(profit) as total_profit
from gold.fact_orders fo
join gold.dim_category dc
    on fo.category_id = dc.category_id
group by dc.category, discount
having
    discount > 0.15 and -- high risk threshold discount , 15%
    sum(profit) > 10000 -- considered high profitability around 10k usd

-- select distinct  discount * 100 as discount from gold.fact_orders order by discount