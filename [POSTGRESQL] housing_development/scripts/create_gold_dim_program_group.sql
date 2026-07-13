CREATE OR REPLACE VIEW gold.dim_program_group AS (
	WITH distinct_list_pg AS (
	SELECT DISTINCT
		program_group
	FROM silver.housedev
	)
	
	SELECT
		('PG' || 10 + ROW_NUMBER() OVER(ORDER BY program_group))::VARCHAR AS program_group_id,
		program_group
	FROM distinct_list_pg
);