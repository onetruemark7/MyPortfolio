--migrating data from Bronze to Silver
insert into silver.superstore (row_id, order_id, customer_id, product_id, first_name, last_name, segment, country, region, state, city, order_priority, order_date, shipdate, ship_mode, product_name, category, sub_category, market, market2, sales, profit, discount, quantity, shipping_cost, year, weeknum)
select
    --primary/foreign keys
    row_id,
    order_id,
    customer_id,
    product_id,

    --customer section
    split_part(customer_name,' ',1) as first_name,
    split_part(customer_name,' ',2) as last_name,
    segment,

    --location section
    country,
    region,
    state,
    city,

    --order section
    order_priority,
    order_date,
    shipdate,
    ship_mode,

    --product section
    product_name,
    category,
    sub_category,
    market,
    market2,

    --measure section
    sales,
    profit,
    discount,
    quantity,
    shipping_cost,

    --date section
    year,
    weeknum


from bronze.superstore
order by order_date asc;

