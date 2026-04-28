/*
14. Find the **streets in Ang Mo Kio** with the highest resale activity for 2-room flats.
*/

SELECT
	dt.town,
	ds.street,
	dft.flat_type,
	COUNT(fr.resale_price) AS transaction_count
FROM gold.fact_records fr
JOIN gold.dim_street ds
	ON fr.street_id = ds.street_id
JOIN gold.dim_flat_type dft
	ON fr.flat_type_id = dft.flat_type_id
JOIN gold.dim_town dt
	ON fr.town_id = dt.town_id
WHERE
	dt.town = 'Ang Mo Kio' AND
	dft.flat_type = '2 Room'
GROUP BY
	dt.town,
	ds.street,
	dft.flat_type
ORDER BY transaction_count DESC;