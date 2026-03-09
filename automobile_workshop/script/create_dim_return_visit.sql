-- create dim return_visit
CREATE OR REPLACE VIEW gold.dim_returnvisit AS (
	WITH dim_returnvisit AS (
	SELECT DISTINCT
		return_visit
	FROM silver.automobile
	)
	
	SELECT
		'PM' || (10+ROW_NUMBER() OVER(ORDER BY return_visit))::TEXT AS return_visit_id,
		return_visit
	FROM dim_returnvisit
);