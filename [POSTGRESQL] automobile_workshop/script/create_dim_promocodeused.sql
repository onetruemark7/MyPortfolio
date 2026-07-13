-- create dim promo code used
CREATE OR REPLACE VIEW gold.dim_promocodeused AS (
	WITH dim_promocodeused AS (
	SELECT DISTINCT
		promo_code_used
	FROM silver.automobile
	)
	
	SELECT
		'PCU' || (10+ROW_NUMBER() OVER(ORDER BY promo_code_used))::TEXT AS promo_code_used_id,
		promo_code_used
	FROM dim_promocodeused
);