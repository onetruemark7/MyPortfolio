-- Customer Analysis Question --
-- What is the average sales value per customer?

select
    dc.first_name|| ' ' ||dc.last_name as customer_name,
    round(avg(fo.sales),2) as average_sales
from gold.fact_order fo
join gold.dim_customer dc
    on fo.customer_id = dc.customer_id
group by dc.first_name, dc.last_name