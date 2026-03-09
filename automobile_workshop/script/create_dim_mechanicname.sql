-- create dim mechanic name
CREATE OR REPLACE VIEW gold.dim_mechanicname AS (
	WITH dim_mechanicname AS (
	SELECT DISTINCT
		mechanic_name
	FROM silver.automobile
	)
	
	SELECT
		'MN' || (10+ROW_NUMBER() OVER(ORDER BY mechanic_name))::TEXT AS mechanic_name_id,
		mechanic_name
	FROM dim_mechanicname
);