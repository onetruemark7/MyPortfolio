/*
Creates Views in gold schema
*/

create or replace view gold.dim_category as
select *
from silver.category;

create or replace view gold.dim_city as
select *
from silver.city;

create or replace view gold.dim_country as
select *
from silver.country;

create or replace view gold.dim_customer as
select *
from silver.customer;

create or replace view gold.dim_market as
select *
from silver.market;

create or replace view gold.dim_market2 as
select *
from silver.market2;

create or replace view gold.dim_order_priority as
select *
from silver.order_priority;

create or replace view gold.dim_product as
select *
from silver.product;

create or replace view gold.dim_region as
select *
from silver.region;

create or replace view gold.dim_segment as
select *
from silver.segment;

create or replace view gold.dim_ship_mode as
select *
from silver.ship_mode;

create or replace view gold.dim_state as
select *
from silver.state;

create or replace view gold.dim_sub_category as
select *
from silver.sub_category;