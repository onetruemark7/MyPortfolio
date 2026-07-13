-- create dim towing_required
CREATE OR REPLACE VIEW gold.dim_towingrequired AS (
	WITH dim_towingrequired AS (
	SELECT DISTINCT
		towing_required
	FROM silver.automobile
	)
	
	SELECT
		'TR' || (10+ROW_NUMBER() OVER(ORDER BY towing_required))::TEXT AS towing_required_id,
		towing_required
	FROM dim_towingrequired
);