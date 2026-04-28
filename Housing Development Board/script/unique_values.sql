/*
identifies column with unique values
*/

SELECT DISTINCT
	year_month_date --shows 112 unique values
FROM bronze.housedev;

SELECT DISTINCT
	town --shows 26 unique values
FROM bronze.housedev;

SELECT DISTINCT
	flat_type --shows 7 unique values
FROM bronze.housedev;

SELECT DISTINCT
	street --shows 557 unique values
FROM bronze.housedev;

SELECT DISTINCT
	storey_range --shows 17 unique values
FROM bronze.housedev;

SELECT DISTINCT
	floor_sqm --shows 189 unique values
FROM bronze.housedev;

SELECT DISTINCT
	flat_model --shows 21 unique values
FROM bronze.housedev;

SELECT DISTINCT
	lease_commence_date --shows 56 unique values
FROM bronze.housedev;

SELECT DISTINCT
	remaining_lease --shows 698 unique values
FROM bronze.housedev;

SELECT DISTINCT
	resale_price --shows 4636 unique values
FROM bronze.housedev;