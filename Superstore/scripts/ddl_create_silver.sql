--create table for silver
CREATE TABLE silver.superstore (
    --primary/foreign keys
    row_id varchar,
    order_id varchar,
    customer_id varchar,
    product_id varchar,

    --customer section
    first_name varchar,
    last_name varchar,
    segment varchar,

    --location section
    country varchar,
    region varchar,
    state varchar,
    city varchar,

    --order section
    order_priority varchar,
    order_date timestamptz,
    shipdate timestamptz,
    ship_mode varchar,

    --product section
    product_name varchar,
    category varchar,
    sub_category varchar,
    market varchar,
    market2 varchar,

    --measure section
    sales numeric,
    profit numeric,
    discount numeric,
    quantity numeric,
    shipping_cost numeric,

    --date section
    year int,
    weeknum int
);