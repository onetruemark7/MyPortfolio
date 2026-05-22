with unique_market as (
    select distinct
        market
    from iron.superstore
)

select
    upper("left"(market,2) ) || row_number() over (order by market) + 100 as market_id,
    market
into silver.market
from unique_market