with unique_order_prio as (
    select distinct
        order_priority
from iron.superstore
)

select
    'OP' || row_number() over (order by order_priority) + 100 as order_priority_id,
    order_priority
into silver.order_priority
from unique_order_prio