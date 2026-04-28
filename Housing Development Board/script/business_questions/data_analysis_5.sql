/*
5. Analyze the **trend of Executive flats** resale prices over the last 10 years.  
*/

SELECT
	DATE_TRUNC('QUARTER', fr.record_date)::DATE AS year_date,
	dft.flat_type,
	SUM(fr.resale_price) AS sum_total,
	ROUND(AVG(fr.resale_price),2) AS avg_resale_price,
	COUNT(*) AS transaction_count,
	MIN(fr.resale_price) AS minimum_resale_price,
	MAX(fr.resale_price) AS maximum_resale_price,
	PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY fr.resale_price) AS median_resale_price
FROM gold.fact_records fr
JOIN gold.dim_flat_type dft
	ON fr.flat_type_id = dft.flat_type_id
WHERE
	dft.flat_type = 'Executive' AND
	fr.record_date >= (SELECT MAX(record_date) FROM gold.fact_records) - INTERVAL '10 years' -- gets the maximum year recorded in subq, then minus 10yrs using INTERVAL
GROUP BY
	DATE_TRUNC('QUARTER', fr.record_date)::DATE,
	dft.flat_type;