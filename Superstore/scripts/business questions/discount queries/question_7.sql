-- Discount Analysis Question
-- Which categories remain profitable despite high discounts?

select
    discount,
    sum(quantity) as total_quantity,
    round(avg(quantity),2) as average_quantity,
    sum(sales) as total_sales,
    sum(profit) as total_profit,
    round(sum(profit) * 100 / sum(sales),2) as profit_margin_pct,
    count(*) as total_order
from gold.fact_orders
group by discount
order by total_quantity desc;

-- higher discounts and lower quantity gives negative profitability
-- lower discounts and higher quantity gives positive profitability