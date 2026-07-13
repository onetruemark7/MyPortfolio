/*
Creates silver table for inbound data from bronze schema
*/

CREATE TABLE silver.housedev (
	record_id VARCHAR PRIMARY KEY DEFAULT UUIDV7(),
	record_date DATE,
	town VARCHAR,
	flat_type VARCHAR,
	block VARCHAR,
	street VARCHAR,
	storey_range_first_number NUMERIC,
	storey_range_second_number NUMERIC,
	floor_sqm NUMERIC,
	flat_model VARCHAR,
	lease_commence_date_as_year INT,
	remaining_lease_in_years INT,
	remaining_lease_in_months INT,
	resale_price NUMERIC,
	created_at DATE DEFAULT CURRENT_TIMESTAMP
);


