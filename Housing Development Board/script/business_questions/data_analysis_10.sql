/*
10. Find the **town with the widest variety of flat models** available.  
*/
WITH flats_count_per_town AS (
	SELECT
		dt.town,
		dfm.flat_model,
		COUNT(DISTINCT dfm.flat_model) AS model_count
	FROM gold.fact_records fr
	JOIN gold.dim_flat_model dfm
		ON fr.flat_model_id = dfm.flat_model_id
	JOIN gold.dim_town dt
		ON fr.town_id = dt.town_id
	GROUP BY
		dt.town,
		dfm.flat_model
)

SELECT
	town,
	SUM(model_count) AS model_count_in_town
FROM flats_count_per_town
GROUP BY town
ORDER BY model_count_in_town DESC
LIMIT 1