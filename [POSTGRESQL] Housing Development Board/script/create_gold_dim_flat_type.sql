/*
Create gold.dim_flat_type View in gold schema
*/

CREATE OR REPLACE VIEW gold.dim_flat_type AS (
	WITH flattype_distinct_list AS (
		SELECT DISTINCT
			flat_type
		FROM silver.housedev
	)
	
	SELECT
		ROW_NUMBER() OVER(ORDER BY flat_type) AS surrogate_key,
		'FT' || 10 + ROW_NUMBER() OVER(ORDER BY flat_type) AS flat_type_id,
		flat_type
	FROM flattype_distinct_list
);