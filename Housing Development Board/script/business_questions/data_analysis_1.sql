/*
1. Find the distribution of flat types across different towns.
*/
WITH count_of_flat_types AS (
	SELECT
		dt.town,
		dft.flat_type,
		COUNT(*) AS number_of_flat_types
	FROM gold.fact_records fr
	JOIN gold.dim_flat_type dft
		ON fr.flat_type_id = dft.flat_type_id
	JOIN gold.dim_town dt
		ON fr.town_id = dt.town_id
	GROUP BY
		dt.town,
		dft.flat_type
)
SELECT
	*,
	ROUND((number_of_flat_types / NULLIF(SUM(number_of_flat_types) OVER(),0)*100),2) AS distribution_pct
FROM count_of_flat_types
ORDER BY distribution_pct DESC;