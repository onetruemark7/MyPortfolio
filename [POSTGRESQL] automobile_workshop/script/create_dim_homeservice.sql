-- create dim home_service
CREATE OR REPLACE VIEW gold.dim_homeservice AS (
	WITH dim_homeservice AS (
	SELECT DISTINCT
		home_service
	FROM silver.automobile
	)
	
	SELECT
		'HS' || (10+ROW_NUMBER() OVER(ORDER BY home_service))::TEXT AS home_service_id,
		home_service
	FROM dim_homeservice
);