-- create dim spare parts availability
CREATE OR REPLACE VIEW gold.dim_sparepartsavailability AS (
	WITH dim_sparepartsavailability AS (
	SELECT DISTINCT
		spare_parts_availability
	FROM silver.automobile
	)
	
	SELECT
		'SPA' || (10+ROW_NUMBER() OVER(ORDER BY spare_parts_availability))::TEXT AS spare_parts_availability_id,
		spare_parts_availability
	FROM dim_sparepartsavailability
);