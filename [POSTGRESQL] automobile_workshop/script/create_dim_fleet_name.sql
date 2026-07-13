-- create dim fleet name
CREATE OR REPLACE VIEW gold.dim_fleetname AS (
	WITH dim_fleetname AS (
	SELECT DISTINCT
		fleet_name
	FROM silver.automobile
	)
	
	SELECT
		'FN' || (10+ROW_NUMBER() OVER(ORDER BY fleet_name))::TEXT AS fleet_name_id,
		fleet_name
	FROM dim_fleetname
);