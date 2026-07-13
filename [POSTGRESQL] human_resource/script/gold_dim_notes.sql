create or replace view gold.dim_notes as (
	with notes_list as (
	select distinct
	notes
	from silver.company_data
	
	)
	select
		'N'||10+row_number() over(order by notes) as notes_id,
		notes
	from notes_list

);

-- select * from gold.dim_notes