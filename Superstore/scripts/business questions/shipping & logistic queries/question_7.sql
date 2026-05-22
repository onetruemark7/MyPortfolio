-- Shipping and Logistic Question
-- Are shipping costs affecting margins?

select
    case
        when shipping_cost >= 0 and shipping_cost <= 100 then '0-100'
        when shipping_cost >= 101 and shipping_cost <= 200 then '101-200'
        when shipping_cost >= 201 and shipping_cost <= 300 then '201-300'
        when shipping_cost >= 301 and shipping_cost <= 400 then '301-400'
        when shipping_cost >= 401 and shipping_cost <= 500 then '401-500'
        when shipping_cost >= 501 and shipping_cost <= 600 then '501-600'
        when shipping_cost >= 601 and shipping_cost <= 700 then '601-700'
        when shipping_cost >= 701 and shipping_cost <= 800 then '701-800'
        else '800+'
    end as shipping_cost_range_in_usd,
    sum(sales) as total_sales,
    round(sum(profit),2) as total_profit,
    round(sum(shipping_cost),2) as total_shipping_cost,
    round(sum(profit) * 100 / sum(sales),2) || '%' as profit_margin_pct,
    count(*) as total_transaction,
    sum(quantity) as total_units_sold
from gold.fact_orders
group by 1
order by total_profit desc;

