-- create dim payment mode
CREATE OR REPLACE VIEW gold.dim_paymentmode AS (
	WITH dim_paymentmode AS (
	SELECT DISTINCT
		payment_mode
	FROM silver.automobile
	)
	
	SELECT
		'PM' || (10+ROW_NUMBER() OVER(ORDER BY payment_mode))::TEXT AS payment_mode_id,
		payment_mode
	FROM dim_paymentmode
);