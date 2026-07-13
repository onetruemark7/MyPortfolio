-- create dim request_for_pickup
CREATE OR REPLACE VIEW gold.dim_requestforpickup AS (
	WITH dim_requestforpickup AS (
	SELECT DISTINCT
		request_for_pickup
	FROM silver.automobile
	)
	
	SELECT
		'RFPI' || (10+ROW_NUMBER() OVER(ORDER BY request_for_pickup))::TEXT AS request_for_pickup_id,
		request_for_pickup
	FROM dim_requestforpickup
);