/*
6. Find the **top 5 towns** with the highest proportion of Premium Apartment Loft flats.  
*/

SELECT
	dt.town,
	COUNT(*) / SUM(COUNT(*)) OVER (PARTITION BY dt.town) AS flat_count
FROM gold.fact_records fr
JOIN gold.dim_flat_model dfm
	ON fr.flat_model_id = dfm.flat_model_id
JOIN gold.dim_town dt
	ON fr.town_id = dt.town_id
WHERE dfm.flat_model = 'Premium Apartment Loft'
GROUP BY
	dt.town
ORDER BY flat_count DESC
LIMIT 5;