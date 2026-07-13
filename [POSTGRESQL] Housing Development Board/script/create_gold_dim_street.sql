/*
Create gold.dim_street View in gold schema
*/

CREATE OR REPLACE VIEW gold.dim_street AS (
	WITH street_distinct_list AS (
		SELECT DISTINCT
			street
		FROM silver.housedev
	)
	
	SELECT
		ROW_NUMBER() OVER(ORDER BY street) AS surrogate_key,
		'S' || 10 + ROW_NUMBER() OVER(ORDER BY street) AS street_id,
		street
	FROM street_distinct_list
);