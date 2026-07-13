/*
9. Calculate the **average resale price per square meter** for each flat type.  
*/

SELECT
	dft.flat_type,
	fr.floor_sqm,
	ROUND(AVG(fr.resale_price),2) AS avg_resale_price
FROM gold.fact_records fr
JOIN gold.dim_flat_type dft
	ON fr.flat_type_id = dft.flat_type_id
GROUP BY
	dft.flat_type,
	fr.floor_sqm