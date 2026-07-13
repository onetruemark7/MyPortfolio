/*
EXPLORATORY DATA ANALYSIS - BASIC AGGREGATIONS [AVERAGE, COUNT, MIN, MAX, SUM, STDDEV, MEDIAN]
*/

-- shows total number of records within a database
SELECT
	COUNT(*) AS total_records
FROM gold.fact_records;

-- shows overall minimum and maximum date
SELECT
	MIN(record_date) AS minimum_record_date,
	MAX(record_date) AS maximum_record_date
FROM gold.fact_records

-- shows average resale price, total sum, total number, minimum and maximum of resale price per town
SELECT
	dt.town,
	ROUND(AVG(fr.resale_price),2) AS average_resale_price,
	SUM(fr.resale_price) AS total_sum,
	COUNT(*) AS total_number,
	MIN(fr.resale_price) AS minimum_resale_price,
	MAX(fr.resale_price) AS maximum_resale_price
FROM gold.fact_records fr
JOIN gold.dim_town dt
	ON fr.town_id = dt.town_id
GROUP BY dt.town
ORDER BY average_resale_price DESC;

-- shows average floor square meter per town
-- shows average floor square meter, total number, minumum and maximum floor per square meter in each town
SELECT
	dt.town,
	ROUND(AVG(fr.floor_sqm),2) AS average_floor_sqm,
	COUNT(*) AS total_number,
	MIN(fr.floor_sqm) AS minimum_floor_sqm,
	MAX(fr.floor_sqm) AS maximum_floor_sqm
FROM gold.fact_records fr
JOIN gold.dim_town dt
	ON fr.town_id = dt.town_id
GROUP BY dt.town
ORDER BY average_floor_sqm DESC;

-- shows average floor square meter, total number, minumum and maximum , and median point floor per square meter in each town
SELECT
	dt.town,
	ROUND(AVG(fr.storey_range_first_number),2) AS average_storey_range_from,
	ROUND(AVG(fr.storey_range_second_number),2) AS average_storey_range_to,
	COUNT(*) AS total_number,
	MIN(fr.storey_range_first_number) AS minimum_storey_range_from,
	MAX(fr.storey_range_second_number) AS maximum_storey_range_to,
	PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY storey_range_first_number) AS median_point
FROM gold.fact_records fr
JOIN gold.dim_town dt
	ON fr.town_id = dt.town_id
GROUP BY dt.town
ORDER BY dt.town;

-- shows average floor square meter, total number, minumum and maximum , and median point floor per square meter in each town
SELECT
	dt.town,
	ROUND(AVG(fr.lease_commence_date_as_year),0) AS average_lease_commence_date_as_year,
	COUNT(*) AS total_number,
	MIN(fr.lease_commence_date_as_year) AS minimum_lease_commence_date_as_year,
	MAX(fr.lease_commence_date_as_year) AS maximum_lease_commence_date_as_year,
	PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY lease_commence_date_as_year) AS median_point
FROM gold.fact_records fr
JOIN gold.dim_town dt
	ON fr.town_id = dt.town_id
GROUP BY dt.town
ORDER BY dt.town;

-- shows average, total number, minumum and maximum , and median point remaining lease per year in each town
SELECT
	dt.town,
	ROUND(AVG(fr.remaining_lease_in_years),2) AS average_remaining_lease_in_years,
	COUNT(*) AS total_number,
	MIN(fr.remaining_lease_in_years) AS minimum_remaining_lease_in_years,
	MAX(fr.remaining_lease_in_years) AS maximum_remaining_lease_in_years,
	PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY remaining_lease_in_years) AS median_point
FROM gold.fact_records fr
JOIN gold.dim_town dt
	ON fr.town_id = dt.town_id
GROUP BY dt.town
ORDER BY dt.town;

-- shows average, total number, minumum and maximum , and median point remaining resale price in each town
SELECT
	ds.street,
	ROUND(AVG(fr.resale_price),2) AS average_resale_price,
	COUNT(*) AS total_number,
	MIN(fr.resale_price) AS minimum_resale_price,
	MAX(fr.resale_price) AS maximum_resale_price,
	PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY resale_price) AS median_point
FROM gold.fact_records fr
JOIN gold.dim_street ds
	ON fr.street_id = ds.street_id
GROUP BY ds.street
ORDER BY ds.street;

-- shows average, total number, minumum and maximum , and median point of floor square per meter in each town
SELECT
	ds.street,
	ROUND(AVG(fr.floor_sqm),2) AS average_floor_sqm,
	COUNT(*) AS total_number,
	MIN(fr.floor_sqm) AS minimum_floor_sqm,
	MAX(fr.floor_sqm) AS maximum_floor_sqm,
	PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY floor_sqm) AS median_point
FROM gold.fact_records fr
JOIN gold.dim_street ds
	ON fr.street_id = ds.street_id
GROUP BY ds.street
ORDER BY ds.street;

-- shows average, total number, minumum and maximum , and median point of storey range in each town
SELECT
	ds.street,
	ROUND(AVG(fr.storey_range_first_number),2) AS average_storey_range_from,
	COUNT(*) AS total_number,
	MIN(fr.storey_range_first_number) AS minimum_floor_sqm,
	MAX(fr.storey_range_second_number) AS maximum_floor_sqm,
	PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY fr.storey_range_first_number) AS median_point
FROM gold.fact_records fr
JOIN gold.dim_street ds
	ON fr.street_id = ds.street_id
GROUP BY ds.street
ORDER BY ds.street;

-- shows average, total number, minumum and maximum , and median point of lease commence date as year in each town
SELECT
	ds.street,
	ROUND(AVG(fr.lease_commence_date_as_year),0) AS average_lease_commence_date_as_year,
	COUNT(*) AS total_number,
	MIN(fr.lease_commence_date_as_year) AS minimum_floor_sqm,
	MAX(fr.lease_commence_date_as_year) AS maximum_floor_sqm,
	PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY fr.lease_commence_date_as_year) AS median_point
FROM gold.fact_records fr
JOIN gold.dim_street ds
	ON fr.street_id = ds.street_id
GROUP BY ds.street
ORDER BY ds.street;

-- shows average, total number, minumum and maximum , and median point of remaining lease in years in each town
SELECT
	ds.street,
	ROUND(AVG(fr.remaining_lease_in_years),2) AS average_remaining_lease_in_years,
	COUNT(*) AS total_number,
	MIN(fr.remaining_lease_in_years) AS minimum_remaining_lease_in_years,
	MAX(fr.remaining_lease_in_years) AS maximum_remaining_lease_in_years,
	PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY fr.remaining_lease_in_years) AS median_point
FROM gold.fact_records fr
JOIN gold.dim_street ds
	ON fr.street_id = ds.street_id
GROUP BY ds.street
ORDER BY ds.street;

-- shows average, total number, minumum and maximum , and median point of resale price in each flat type
SELECT
	dft.flat_type,
	ROUND(AVG(fr.resale_price),2) AS average_resale_price,
	COUNT(*) AS total_number,
	MIN(fr.remaining_lease_in_years) AS minimum_remaining_lease_in_years,
	MAX(fr.remaining_lease_in_years) AS maximum_remaining_lease_in_years,
	PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY fr.remaining_lease_in_years) AS median_point
FROM gold.fact_records fr
JOIN gold.dim_flat_type dft
	ON fr.flat_type_id = dft.flat_type_id
GROUP BY dft.flat_type
ORDER BY dft.flat_type;

-- Calculates average floor per square meter date in year, total number, minimum and maximum floor per square meter, standard deviation, and median point in each flat type
SELECT
	dft.flat_type,
	ROUND(AVG(fr.floor_sqm),2) AS average_floor_sqm,
	COUNT(*) AS total_number,
	MIN(fr.floor_sqm) AS minimum_floor_sqm,
	MAX(fr.floor_sqm) AS maximum_floor_sqm,
	ROUND(STDDEV_SAMP(fr.floor_sqm),2) AS std_dev_floor_sqm,
	PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY fr.floor_sqm)AS median_point
FROM gold.fact_records fr
JOIN gold.dim_flat_type dft
	ON fr.flat_type_id = dft.flat_type_id
GROUP BY dft.flat_type
ORDER BY dft.flat_type;

-- shows average storey range in each flat type
SELECT
	dft.flat_type,
	ROUND(AVG(fr.storey_range_first_number),2) AS average_storey_range_from,
	ROUND(AVG(fr.storey_range_second_number),2) AS average_storey_range_to
FROM gold.fact_records fr
JOIN gold.dim_flat_type dft
	ON fr.flat_type_id = dft.flat_type_id
GROUP BY dft.flat_type
ORDER BY average_storey_range_from, average_storey_range_to;

-- Calculates average lease commence date in year, total number, minimum and maximum lease commencement, standard deviation, and median point in each flat type
SELECT
	dft.flat_type,
	ROUND(AVG(fr.lease_commence_date_as_year),0) AS average_lease_commence_date_in_year,
	COUNT(*) AS total_number,
	MIN(lease_commence_date_as_year) AS minimum_lease_commence_date_as_year,
	MAX(lease_commence_date_as_year) AS maximum_lease_commence_date_as_year,
	ROUND(STDDEV_SAMP(lease_commence_date_as_year),0) AS std_dev_lease_commence_date_as_year,
	PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY lease_commence_date_as_year)AS median_point
FROM gold.fact_records fr
JOIN gold.dim_flat_type dft
	ON fr.flat_type_id = dft.flat_type_id
GROUP BY dft.flat_type
ORDER BY dft.flat_type;

-- Calculates average remaining lease in years and months, total number, minimum and maximum remaining lease in years and months, standard deviation, and median point in each flat type
SELECT
	dft.flat_type,
	ROUND(AVG(fr.remaining_lease_in_years),0) AS average_remaining_lease_in_years,
	ROUND(AVG(fr.remaining_lease_in_months),0) AS average_remaining_lease_in_months,
	COUNT(*) AS total_number,
	MIN(fr.remaining_lease_in_years) AS minimum_remaining_lease_in_years,
	MAX(fr.remaining_lease_in_years) AS maximum_remaining_lease_in_years,
	MIN(fr.remaining_lease_in_months) AS minimum_remaining_lease_in_months,
	MAX(fr.remaining_lease_in_months) AS maximum_remaining_lease_in_months,
	ROUND(STDDEV_SAMP(fr.remaining_lease_in_years),2) AS std_dev_remaining_lease_in_years,
	PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY fr.remaining_lease_in_years)AS median_point_remaining_lease_in_years
FROM gold.fact_records fr
JOIN gold.dim_flat_type dft
	ON fr.flat_type_id = dft.flat_type_id
GROUP BY dft.flat_type
ORDER BY dft.flat_type;

-- Calculates average resale price, total number, minimum and maximum resale price, standard deviation, median point in each flat model
SELECT
	dfm.flat_model,
	ROUND(AVG(fr.resale_price),2) AS average_resale_price,
	COUNT(*) AS total_number,
	MIN(fr.resale_price) AS minimum_resale_price,
	MAX(fr.resale_price) AS maximum_resale_price,
	ROUND(STDDEV_SAMP(fr.resale_price),2) AS std_dev_resale_price,
	PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY fr.resale_price)AS median_point_resale_price
FROM gold.fact_records fr
JOIN gold.dim_flat_model dfm
	ON fr.flat_model_id = dfm.flat_model_id
GROUP BY dfm.flat_model
ORDER BY dfm.flat_model;

-- Calculates average floor per square meter, total number, minimum and maximum floor per square meter, standard deviation, median point in each flat model
SELECT
	dfm.flat_model,
	ROUND(AVG(fr.floor_sqm),2) AS average_floor_sqm,
	COUNT(*) AS total_number,
	MIN(fr.floor_sqm) AS minimum_floor_sqm,
	MAX(fr.floor_sqm) AS maximum_floor_sqm,
	ROUND(STDDEV_SAMP(fr.floor_sqm),2) AS std_dev_floor_sqm,
	PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY fr.floor_sqm)AS median_point_floor_sqm
FROM gold.fact_records fr
JOIN gold.dim_flat_model dfm
	ON fr.flat_model_id = dfm.flat_model_id
GROUP BY dfm.flat_model
ORDER BY dfm.flat_model;

-- Calculates average lease commencement, total number, minimum and maximum lease commencement, standard deviation, median point in each flat model
SELECT
	dfm.flat_model,
	ROUND(AVG(fr.lease_commence_date_as_year),0) AS average_lease_commence_date_as_year,
	COUNT(*) AS total_number,
	MIN(fr.lease_commence_date_as_year) AS minimum_lease_commence_date_as_year,
	MAX(fr.lease_commence_date_as_year) AS maximum_lease_commence_date_as_year,
	ROUND(STDDEV_SAMP(fr.lease_commence_date_as_year),2) AS std_dev_lease_commence_date_as_year,
	PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY fr.lease_commence_date_as_year)AS median_point_lease_commence_date_as_year
FROM gold.fact_records fr
JOIN gold.dim_flat_model dfm
	ON fr.flat_model_id = dfm.flat_model_id
GROUP BY dfm.flat_model
ORDER BY dfm.flat_model;

