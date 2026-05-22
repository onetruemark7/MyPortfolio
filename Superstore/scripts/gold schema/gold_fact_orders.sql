create or replace view gold.fact_order as
select
    irs.row_id,
    irs.order_id,

    sc.category_id,
    sci.city_id,
    sco.country_id,
    scu.customer_id,
    sm.market_id,
    sma.market2_id,
    sop.order_priority_id,
    sr.region_id,
    ssm.ship_mode_id,
    ss.state_id,
    ssca.sub_category_id,
    sse.segment_id,
    sp.product_id,

    irs.order_date::date,
    irs.shipdate::date,
    irs.sales,
    irs.profit,
    irs.quantity,
    irs.discount,
    irs.shipping_cost
from iron.superstore irs
join silver.category sc
    on irs.category = sc.category
join silver.city sci
    on irs.city = sci.city
join silver.country sco
    on irs.country = sco.country
join silver.customer scu
    on irs.customer_id = scu.customer_id
join silver.market sm
    on irs.market = sm.market
join silver.market2 sma
    on irs.market2 = sma.market2
join silver.order_priority sop
    on irs.order_priority = sop.order_priority
join silver.region sr
    on irs.region = sr.region
join silver.ship_mode ssm
    on irs.ship_mode = ssm.ship_mode
join silver.state ss
    on irs.state = ss.state
join silver.sub_category ssca
    on irs.sub_category = ssca.sub_category
join silver.segment sse
    on irs.segment = sse.segment
join silver.product sp
    on irs.product_id = sp.product_id
