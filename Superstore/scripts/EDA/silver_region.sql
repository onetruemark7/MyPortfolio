with unique_region as (
    select distinct
        region
    from iron.superstore
    order by region
)

select
    upper("left"(region,2)) || row_number() over (order by region) + 100 as region_id,
    region
into silver.region
from unique_region
