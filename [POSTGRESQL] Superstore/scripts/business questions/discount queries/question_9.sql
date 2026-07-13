-- Discount Analysis Question
-- Are there cases where no discount yields better profits?

with overall_discount_profit as (
    select
        discount,
        sum(profit) as total_profit
    from gold.fact_orders
    group by discount
    order by total_profit desc
)

select
    *,
    row_number() over (
    order by total_profit desc) as rank_by_profit_desc
from overall_discount_profit