-- create dim has_insurance_cover
CREATE OR REPLACE VIEW gold.dim_hasinsurancecover AS (
	WITH dim_hasinsurancecover AS (
	SELECT DISTINCT
		has_insurance_cover
	FROM silver.automobile
	)
	
	SELECT
		'HIC' || (10+ROW_NUMBER() OVER(ORDER BY has_insurance_cover))::TEXT AS has_insurance_cover_id,
		has_insurance_cover
	FROM dim_hasinsurancecover
);