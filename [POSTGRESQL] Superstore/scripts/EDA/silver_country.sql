with unique_country as (
    select distinct
        country
    from iron.superstore
    order by country
)

select
    upper("left"(country,2)) || row_number() over(order by country) + 100 as country_id,
    country
into silver.country
from unique_country