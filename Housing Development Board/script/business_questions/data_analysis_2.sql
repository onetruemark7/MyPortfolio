/*
2. Identify the **most common flat model** in each town.  
*/
WITH subtotal_town AS (
		SELECT
		dt.town,
		dfm.flat_model,
		COUNT(*) AS subtotal_count
	FROM gold.fact_records fr
	JOIN gold.dim_flat_model dfm
		ON fr.flat_model_id = dfm.flat_model_id
	JOIN gold.dim_town dt
		ON fr.town_id = dt.town_id
	GROUP BY
		dt.town,
		dfm.flat_model
), rank_by_count AS (
	SELECT
		*,
		ROW_NUMBER() OVER(
			PARTITION BY town
			ORDER BY subtotal_count DESC
		) AS ranking
	FROM subtotal_town
)
SELECT
	*
FROM rank_by_count
WHERE ranking = 1
