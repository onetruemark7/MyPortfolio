create or replace view gold.dim_country as (
	with country_fullname as (
	select distinct
		country_full
	from silver.company_data
	)
	
	select
		'C'||10+row_number() over(order by country_full) as country_id,
		country_full as country
	from country_fullname

);

-- select * from gold.dim_country