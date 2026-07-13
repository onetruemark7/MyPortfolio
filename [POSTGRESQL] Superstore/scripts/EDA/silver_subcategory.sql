with unique_subcategory as (
    select distinct
        sub_category
    from iron.superstore
)

select
    'SC' || row_number() over (order by sub_category) + 100 as sub_category_id,
    sub_category
into silver.sub_category
from unique_subcategory