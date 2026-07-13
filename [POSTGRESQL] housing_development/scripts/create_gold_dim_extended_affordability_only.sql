CREATE OR REPLACE VIEW gold.dim_extended_affordability_only AS (
	WITH distinct_list_eao AS (
	SELECT DISTINCT
		extended_affordability_only
	FROM silver.housedev
	)
	
	SELECT
		('EAO' || 10+ROW_NUMBER() OVER(ORDER BY extended_affordability_only))::VARCHAR AS extended_affordability_only_id,
		extended_affordability_only
	FROM distinct_list_eao
);