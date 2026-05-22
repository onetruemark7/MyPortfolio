-- Customer Analysis Question --
-- What products are preferred by each customer segment?

with order_count as (
    select
        ds.segment as segment,
        dp.product_name as product,
        count(*) as total_orders
    from gold.fact_order fo
    join gold.dim_product dp
        on fo.product_id = dp.product_id
    join gold.dim_segment ds
        on fo.segment_id = ds.segment_id
    group by
        dp.product_name,
        ds.segment
)
, ranked_product_by_orders as (
    select
        segment,
        product,
        total_orders,
        row_number() over (
            partition by segment
            order by total_orders desc
        ) as product_rank
    from order_count
)

select * from ranked_product_by_orders where product_rank < 11
