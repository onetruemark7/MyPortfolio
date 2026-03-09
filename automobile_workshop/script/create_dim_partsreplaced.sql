-- create dim parts replaced
CREATE OR REPLACE VIEW gold.dim_partsreplaced AS (
	WITH dimpartsreplaced AS (
	SELECT DISTINCT
		parts_replaced
	FROM silver.automobile
	)
	
	SELECT
		'PR' || (10+ROW_NUMBER() OVER(ORDER BY parts_replaced))::TEXT AS partsreplaced_id,
		parts_replaced
	FROM dimpartsreplaced
);