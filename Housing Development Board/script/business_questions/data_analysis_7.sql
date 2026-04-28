/*
7. Compare the **average resale price difference** between Model A and Model A-Maisonette flats.  
*/
WITH avg_resaleprice_flats AS (
	SELECT
		dfm.flat_model,
		AVG(fr.resale_price) AS avg_resale_price
	FROM gold.fact_records fr
	JOIN gold.dim_flat_model dfm
		ON fr.flat_model_id = dfm.flat_model_id
	WHERE
		dfm.flat_model = 'Model A' OR
		dfm.flat_model = 'Model A-Maisonette'
	GROUP BY
		dfm.flat_model
)
SELECT
	flat_model,
	ROUND(avg_resale_price,2) AS avg_resale_price,
	ROUND(ABS(NTH_VALUE(avg_resale_price,1) OVER() - NTH_VALUE(avg_resale_price,2) OVER()),2) AS avg_resale_price_difference,
	ROUND(((avg_resale_price / SUM(avg_resale_price) OVER())*100),2) || '%' AS pct_difference
FROM avg_resaleprice_flats