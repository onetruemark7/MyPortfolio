-- create dim workshop location
CREATE OR REPLACE VIEW gold.dim_workshoplocation AS (
	WITH dim_workshoplocation AS (
	SELECT DISTINCT
		workshop_location
	FROM silver.automobile
	)
	
	SELECT
		'WL' || (10+ROW_NUMBER() OVER(ORDER BY workshop_location))::TEXT AS workshop_location_id,
		workshop_location
	FROM dim_workshoplocation
);