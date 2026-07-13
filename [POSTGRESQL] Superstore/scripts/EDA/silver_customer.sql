-- create customer table in silver schema
create table silver.customer as (
    select distinct
        customer_id,
        first_name,
        last_name
    from iron.superstore
);
