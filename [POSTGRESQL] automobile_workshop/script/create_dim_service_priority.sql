-- create dim service priority
CREATE OR REPLACE VIEW gold.dim_servicepriority AS (
	WITH dim_servicepriority AS (
	SELECT DISTINCT
		service_priority
	FROM silver.automobile
	)
	
	SELECT
		'SP' || (10+ROW_NUMBER() OVER(ORDER BY service_priority))::TEXT AS service_priority_id,
		service_priority
	FROM dim_servicepriority
);