create or replace view gold.dim_state as(
	with state_fullname as (
	select distinct
		state_full
	from silver.company_data
	)
	
	select
		'S'||10+row_number() over(order by state_full) as state_id,
		state_full
	from state_fullname
);

-- select * from gold.dim_state