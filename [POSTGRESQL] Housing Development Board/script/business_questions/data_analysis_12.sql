/*
12. Identify the **least common flat type** across all towns.  
*/

SELECT
	dft.flat_type,
	COUNT(*) AS flat_type_count
FROM gold.fact_records fr
JOIN gold.dim_flat_type dft
	ON fr.flat_type_id = dft.flat_type_id
GROUP BY
	dft.flat_type
ORDER BY flat_type_count ASC
LIMIT 1;