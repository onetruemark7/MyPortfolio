/*
3. Compare the **average resale price** of 4-room flats between Bedok and Tampines.  
*/

SELECT
	dt.town,
	dft.flat_type,
	ROUND(AVG(fr.resale_price),2) AS avg_resale_price
FROM gold.fact_records fr
JOIN gold.dim_town dt
	ON fr.town_id = dt.town_id
JOIN gold.dim_flat_type dft
	ON fr.flat_type_id = dft.flat_type_id
WHERE
	dt.town = 'Bedok' AND
	dft.flat_type = '4 Room' OR
	dt.town = 'Tampines' AND
	dft.flat_type = '4 Room'
GROUP BY 
	dt.town,
	dft.flat_type
ORDER BY dt.town