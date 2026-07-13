select
    product_id,
    product_name
into silver.product
from
    (select
        product_id,
        product_name,
        row_number() over(partition by product_id) as entry
    from iron.superstore)m
where entry < 2