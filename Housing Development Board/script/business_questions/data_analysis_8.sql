/*
8. Identify the **streets in Yishun** where 3-room flats are most frequently sold.  
*/

SELECT
	ds.street,
	SUM(fr.resale_price) AS sum_total
FROM gold.fact_records fr
JOIN gold.dim_town dt
	ON fr.town_id = dt.town_id
JOIN gold.dim_street ds
	ON fr.street_id = ds.street_id
JOIN gold.dim_flat_type dft
	ON fr.flat_type_id = dft.flat_type_id
WHERE dft.flat_type = '3 Room' AND ds.street ~ 'Yishun'
GROUP BY
	ds.street
ORDER BY sum_total DESC