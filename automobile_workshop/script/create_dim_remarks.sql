-- create dim remarks
CREATE OR REPLACE VIEW gold.dim_remarks AS (
	WITH dim_remarks AS (
	SELECT DISTINCT
		remarks
	FROM silver.automobile
	)
	
	SELECT
		'R' || (10+ROW_NUMBER() OVER(ORDER BY remarks))::TEXT AS remarks_id,
		remarks
	FROM dim_remarks
);