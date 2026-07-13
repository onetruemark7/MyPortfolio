-- create dim fuel topup
CREATE OR REPLACE VIEW gold.dim_fueltopup AS (
	WITH dim_fueltopup AS (
	SELECT DISTINCT
		fuel_topup
	FROM silver.automobile
	)
	
	SELECT
		'FTU' || (10+ROW_NUMBER() OVER(ORDER BY fuel_topup))::TEXT AS fuel_topup_id,
		fuel_topup
	FROM dim_fueltopup
);