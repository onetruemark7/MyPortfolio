with unique_state as (
    select distinct
        state
    from iron.superstore
)

select
    'ST' || row_number() over (order by state) + 100 as state_id,
    state
into silver.state
from unique_state