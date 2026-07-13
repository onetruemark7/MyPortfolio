/*
Create gold.dim_town View in gold schema
*/

CREATE OR REPLACE VIEW gold.dim_town AS (
	WITH town_distinct_list AS(
		SELECT DISTINCT
			town
		FROM silver.housedev
	)
	
	SELECT
		ROW_NUMBER() OVER(ORDER BY town) AS surrogate_key,
		'T' || 10 + ROW_NUMBER() OVER(ORDER BY town) AS town_id,
		town
	FROM town_distinct_list
);
