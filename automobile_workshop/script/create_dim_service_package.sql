-- create dim service package
CREATE OR REPLACE VIEW gold.dim_servicepackage AS (
	WITH dim_servicepackage AS (
	SELECT DISTINCT
		service_package
	FROM silver.automobile
	)
	
	SELECT
		'SP' || (10+ROW_NUMBER() OVER(ORDER BY service_package))::TEXT AS service_package_id,
		service_package
	FROM dim_servicepackage
);