/*
Create gold.fact_records View in gold schema
*/

CREATE OR REPLACE VIEW gold.fact_records AS (
	SELECT
		hd.record_id,
		hd.record_date,
		dt.town_id,
		dft.flat_type_id,
		hd.block,
		ds.street_id,
		hd.storey_range_first_number,
		hd.storey_range_second_number,
		hd.floor_sqm,
		dfm.flat_model_id,
		hd.lease_commence_date_as_year,
		hd.remaining_lease_in_years,
		hd.remaining_lease_in_months,
		hd.resale_price
	FROM silver.housedev hd
	JOIN gold.dim_town dt
		ON hd.town = dt.town
	JOIN gold.dim_flat_type dft
		ON hd.flat_type = dft.flat_type
	JOIN gold.dim_street ds
		ON hd.street = ds.street
	JOIN gold.dim_flat_model dfm
		ON hd.flat_model = dfm.flat_model
	ORDER BY record_id
);
