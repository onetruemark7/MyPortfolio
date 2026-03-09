-- create dim status
CREATE OR REPLACE VIEW gold.dim_status AS (
	WITH dim_status AS (
	SELECT DISTINCT
		status
	FROM silver.automobile
	)
	
	SELECT
		'S' || (10+ROW_NUMBER() OVER(ORDER BY status))::TEXT AS status_id,
		status
	FROM dim_status
);