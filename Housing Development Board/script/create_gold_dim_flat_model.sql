/*
Create gold.dim_flat_model View in gold schema
*/

CREATE OR REPLACE VIEW gold.dim_flat_model AS (
	WITH flatmodel_distinct_list AS (
		SELECT DISTINCT
		flat_model
		FROM silver.housedev
	)
	
	SELECT
		ROW_NUMBER() OVER(ORDER BY CURRENT_TIMESTAMP ASC) AS surrogate_key,
		'FL' || 10 + ROW_NUMBER() OVER(ORDER BY CURRENT_TIMESTAMP ASC) AS flat_model_id,
		flat_model
	FROM flatmodel_distinct_list
);