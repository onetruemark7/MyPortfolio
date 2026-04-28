-- create table bronze for ingesting raw data

CREATE TABLE bronze.housedev (
	year_month_date VARCHAR,
	town VARCHAR,
	flat_type VARCHAR,
	block VARCHAR,
	street VARCHAR,
	storey_range VARCHAR,
	floor_sqm NUMERIC,
	flat_model VARCHAR,
	lease_commence_date INT,
	remaining_lease VARCHAR,
	resale_price NUMERIC
);
