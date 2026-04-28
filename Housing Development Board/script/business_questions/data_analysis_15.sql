/*
15. Analyze the **resale price distribution** of Maisonette flats across different towns.  
*/
WITH dist_rank AS (
	SELECT
		dfm.flat_model,
		SUM(fr.resale_price) AS total_sum,
		DENSE_RANK() OVER(ORDER BY SUM(fr.resale_price) DESC) AS rank_distribution
	FROM gold.fact_records fr
	JOIN gold.dim_flat_model dfm
		ON fr.flat_model_id = dfm.flat_model_id
	GROUP BY dfm.flat_model
)

SELECT*
FROM
(SELECT
	*,
	ROUND(((total_sum / NULLIF(SUM(total_sum) OVER(),0))*100),2) AS pct_distribution
FROM dist_rank)
WHERE flat_model = 'Maisonette'