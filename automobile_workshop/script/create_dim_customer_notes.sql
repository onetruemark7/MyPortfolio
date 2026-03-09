-- create dim customer notes
CREATE OR REPLACE VIEW gold.dim_customernotes AS (
	WITH dim_customernotes AS (
	SELECT DISTINCT
		customer_notes
	FROM silver.automobile
	)
	
	SELECT
		'CN' || (10+ROW_NUMBER() OVER(ORDER BY customer_notes))::TEXT AS customer_notes_id,
		customer_notes
	FROM dim_customernotes
);