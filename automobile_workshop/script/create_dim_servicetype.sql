-- create dim servicetype
CREATE OR REPLACE VIEW gold.dim_servicetype AS (
	WITH distinct_servicetype AS (
	SELECT DISTINCT
		service_type
	FROM silver.automobile
	)
	
	SELECT
		'ST' || (10 + ROW_NUMBER() OVER(ORDER BY service_type))::TEXT AS servicetypeid,
		service_type
	FROM distinct_servicetype
);