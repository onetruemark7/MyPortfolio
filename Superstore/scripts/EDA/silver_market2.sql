with unique_market2 as (
    select distinct
        market2
    from iron.superstore
)

select
    upper("left"(market2,2) ) || row_number() over (order by market2) + 100 as market2_id,
    market2
into silver.market2
from unique_market2