/*
11. Compare the **resale price growth rate** of 5-room flats in Jurong East vs Jurong West.  
*/
WITH sum_town_flattypes AS (
	SELECT
		dt.town,
		dft.flat_type,
		SUM(fr.resale_price) AS sum_total
	FROM gold.fact_records fr 
	JOIN gold.dim_town dt
		ON fr.town_id = dt.town_id
	JOIN gold.dim_flat_type dft
		ON fr.flat_type_id = dft.flat_type_id
	WHERE 
		dft.flat_type = '5 Room'
	
	GROUP BY
		dt.town,
		dft.flat_type
)
SELECT
	*,
	ROUND((sum_total / NULLIF(SUM(sum_total) OVER(),0)*100),2) || '%' AS growth_rate
FROM sum_town_flattypes
WHERE town IN ('Jurong East','Jurong West')