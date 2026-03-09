-- create dim parts source
CREATE OR REPLACE VIEW gold.dim_partssource AS (
	WITH dimparts_source AS (
	SELECT DISTINCT
		parts_source
	FROM silver.automobile
	)
	
	SELECT
		'PS' || (10+ROW_NUMBER() OVER(ORDER BY parts_source))::TEXT AS parts_source_id,
		parts_source
	FROM dimparts_source
);