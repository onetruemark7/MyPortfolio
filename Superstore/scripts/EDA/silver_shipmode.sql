with unique_shipmode as (
    select distinct
        ship_mode
    from iron.superstore
)

select
    'SM' || row_number() over (order by ship_mode) + 100 as ship_mode_id,
    ship_mode
into silver.ship_mode
from unique_shipmode