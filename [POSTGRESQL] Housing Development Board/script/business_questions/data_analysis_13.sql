/*
13. Determine the **average resale price difference** between Multi-Generation flats and Executive flats.  
*/
SELECT
	flat_type,
	ROUND(avg_resale_price,2) AS avg_resale_price,
	ROUND(MAX(avg_resale_price) OVER() - MIN(avg_resale_price) OVER(),2) AS avg_difference
FROM
	(SELECT
		dft.flat_type,
		AVG(fr.resale_price) AS avg_resale_price
	FROM gold.fact_records fr
	JOIN gold.dim_flat_type dft
		ON fr.flat_type_id = dft.flat_type_id
	GROUP BY
		dft.flat_type)
WHERE
	flat_type = 'Multi-Generation' OR
	flat_type = 'Executive'