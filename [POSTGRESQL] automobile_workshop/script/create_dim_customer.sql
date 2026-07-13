-- create dim customer
CREATE OR REPLACE VIEW gold.Dim_Customer AS (
	SELECT
		customer_id, 
		first_name , 
		last_name , 
		phone , 
		vehicle_type , 
		plate_number 
	FROM silver.automobile
);