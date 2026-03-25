create or replace view gold.office_type as (
	with officetype as (
	select distinct
		office_type
	from silver.company_data
	)
	
	select
		'OT'||10+row_number() over(order by office_type) as office_type_id,
		office_type
	from officetype
);

-- select * from gold.office_type
