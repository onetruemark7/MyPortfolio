/*
Loads clean data to silver schema
*/

INSERT INTO silver.housedev (
	record_date ,
	town ,
	flat_type ,
	block ,
	street ,
	storey_range_first_number ,
	storey_range_second_number ,
	floor_sqm ,
	flat_model ,
	lease_commence_date_as_year ,
	remaining_lease_in_years ,
	remaining_lease_in_months ,
	resale_price 
)
SELECT
	TO_DATE(year_month_date||'-01','YYYY-MM-dd') AS record_date,

	INITCAP(TRIM(town)) AS town,

	INITCAP(TRIM(flat_type)) AS flat_type,

	TRIM(block) AS block,

	INITCAP(TRIM(street)) AS street,

	SPLIT_PART(storey_range,' ',1)::NUMERIC AS storey_range_first_number,
	SPLIT_PART(storey_range,' ',3)::NUMERIC AS storey_range_second_number,

	floor_sqm,

	INITCAP(TRIM(flat_model)) AS flat_model,

	lease_commence_date AS lease_commence_date_as_year,

	SPLIT_PART(remaining_lease,' ',1)::NUMERIC AS remaining_lease_in_years,

	CASE
		WHEN SPLIT_PART(remaining_lease,' ',3) = '' THEN COALESCE(NULLIF(SPLIT_PART(remaining_lease,' ',3),''),'0')::NUMERIC
		ELSE SPLIT_PART(remaining_lease,' ',3)::NUMERIC
	END AS remaining_lease_in_months,

	resale_price
FROM bronze.housedev;