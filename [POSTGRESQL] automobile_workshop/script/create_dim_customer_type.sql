-- create dim customer type
CREATE OR REPLACE VIEW gold.dim_customertype AS (
	WITH dim_customertype AS (
	SELECT DISTINCT
		customer_type
	FROM silver.automobile
	)
	
	SELECT
		'CT' || (10+ROW_NUMBER() OVER(ORDER BY customer_type))::TEXT AS customer_type_id,
		customer_type
	FROM dim_customertype
);