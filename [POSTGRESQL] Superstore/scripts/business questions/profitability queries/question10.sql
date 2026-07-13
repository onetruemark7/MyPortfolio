-- Profitability Questions --
-- Are discounts significantly impacting profits?

select
    case
        WHEN discount = 0 THEN '0% - No Discount'
        WHEN discount <= 0.1 THEN '0.1 - 10%'
        WHEN discount <= 0.2 THEN '10.1 - 20%'
        WHEN discount <= 0.3 THEN '20.1 - 30%'
        WHEN discount <= 0.4 THEN '30.1 - 40%'
        ELSE '40%+'
    end as discount_bucket, -- segmented then aggregated based on discount range, whichever discount appears profitable.

        COUNT(*) AS total_orders,
        AVG(discount) AS avg_discount,
        SUM(sales) AS total_sales,
        SUM(profit) AS total_profit,
        ROUND(SUM(profit) * 100.0 / NULLIF(SUM(sales), 0), 2) AS overall_profit_margin_pct
from gold.fact_order
group by discount_bucket
order by discount_bucket;
