/*
4. Determine which **street in Hougang** has the highest number of resale transactions.  
*/

SELECT
	dt.town,
	ds.street,
	COUNT(*) AS number_resale_transaction
FROM gold.fact_records fr
JOIN gold.dim_town dt
	ON fr.town_id = dt.town_id
JOIN gold.dim_street ds
	ON fr.street_id = ds.street_id
WHERE dt.town = 'Hougang'
GROUP BY
	dt.town,
	ds.street
ORDER BY number_resale_transaction DESC
LIMIT 1;