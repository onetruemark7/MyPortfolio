with unique_segment as (
    select distinct
        segment
    from iron.superstore
)

select
    'SE' || row_number() over (order by segment) + 100 as segment_id,
    segment
into silver.segment
from unique_segment
