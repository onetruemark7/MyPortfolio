-- checks null
SELECT
	customer_id 
FROM bronze.automobile
WHERE customer_id IS null

-- counts all rows
SELECT
	COUNT(*)
FROM bronze.automobile

SELECT -- checks for dupe records
	customer_id,
	COUNT(*) AS id
FROM bronze.automobile
GROUP BY customer_id
HAVING COUNT(*) > 1

SELECT
	date
FROM bronze.automobile
WHERE date ~ '[A-Za-z]' OR -- checks string values
	date IS NULL OR -- checks nulls
	date = '' -- checks empty strings

SELECT
	customer_name
FROM bronze.automobile
WHERE customer_name IS NULL OR
	customer_name ~ '[0-9]' OR
	customer_name = ''

SELECT
	phone
FROM bronze.automobile
WHERE phone IS NULL OR
	phone ~ '[A-Za-z]]' OR
	phone = ''

SELECT
	vehicle_type
FROM bronze.automobile
WHERE vehicle_type IS NULL OR
	vehicle_type = '' OR
	vehicle_type != TRIM(vehicle_type)


SELECT
	plate_number
FROM bronze.automobile
WHERE plate_number IS NULL OR
	plate_number = '' OR
	plate_number != TRIM(plate_number)

service_type
SELECT
	service_type
FROM bronze.automobile
WHERE service_type IS NULL OR
	service_type = '' OR
	service_type != TRIM(service_type)

complaint
SELECT
	COALESCE(complaint,'Unknown')
FROM bronze.automobile
WHERE complaint IS NULL OR
	complaint = '' OR
	complaint != TRIM(complaint)

SELECT DISTINCT
	complaint,
	CASE
		WHEN complaint ILIKE '%brake%' THEN 'Brake Failure'
		WHEN complaint ILIKE '%eng%' OR complaint ILIKE '%enj%' THEN 'Engine Knocking'
		WHEN complaint ILIKE '%oil%' THEN 'Oil Change'
		WHEN complaint ILIKE '%suspe%' THEN 'Suspension Noise'
		ELSE COALESCE(complaint,'Unknown')
	END AS complaint_clean
FROM bronze.automobile
ORDER BY complaint

parts_replaced
SELECT
	COALESCE(parts_replaced,'Unknown')
FROM bronze.automobile
WHERE parts_replaced IS NULL OR
	parts_replaced = '' OR
	parts_replaced != TRIM(parts_replaced)

SELECT DISTINCT
	mechanic_name
FROM bronze.automobile
WHERE mechanic_name IS NULL OR
	mechanic_name = '' OR
	mechanic_name != TRIM(mechanic_name) OR
	mechanic_name ~ '[0-9]'

SELECT
	service_cost
FROM bronze.automobile
WHERE
	service_cost IS NULL OR
	service_cost < 0 OR
	service_cost::TEXT != TRIM(service_cost::TEXT) OR
	--service_cost::TEXT ~ '%[A-Za-z!@#$%^&*()_+\-=\[\]{}|;:,.<>?/\\]%'
	service_cost::TEXT !~ '^\d+(\.\d+)?$'

SELECT DISTINCT
	payment_mode,
	REGEXP_REPLACE(payment_mode,'pos','POS','g') AS clean0,
	CASE
		WHEN payment_mode ILIKE '%trans%' THEN 'Transfer'
		WHEN payment_mode ILIKE '%cash%' THEN 'Cash'
		WHEN payment_mode ILIKE '%pos%' THEN 'POS'
		ELSE TRIM(payment_mode)
	END AS clean1
FROM bronze.automobile

SELECT DISTINCT
	workshop_location,
	REGEXP_REPLACE(workshop_location,'(?i)whatsa','Whatsapp','g') AS workshop_location
FROM bronze.automobile

SELECT DISTINCT
	request_for_pickup,
	CASE
		WHEN request_for_pickup ILIKE '%y%' THEN 'Yes'
		WHEN request_for_pickup ILIKE '%n%' THEN 'No'
		ELSE COALESCE(request_for_pickup,'To be asked')
	END
FROM bronze.automobile

SELECT DISTINCT
	request_for_pickup,
	COUNT(*)
FROM bronze.automobile
GROUP BY request_for_pickup

SELECT DISTINCT
	service_package,
	COUNT(*)
FROM bronze.automobile
GROUP BY service_package



SELECT DISTINCT
	service_package,
	COALESCE(
		REGEXP_REPLACE(
			REGEXP_REPLACE(service_package,'.*gold.*','Gold Maintenance Plan','i')
		,'.*one.*','One Time','i')
	,'One Time') AS service_package
FROM bronze.automobile
GROUP BY service_package


SELECT DISTINCT
	whatsapp_followup,
	CASE
		WHEN whatsapp_followup ILIKE '%y%' OR whatsapp_followup ILIKE '%yes%' THEN 'Yes'
		WHEN whatsapp_followup ILIKE '%n%' OR whatsapp_followup ILIKE '%no%' THEN 'No'
		WHEN whatsapp_followup ILIKE '%followed up%' THEN 'Followed Up'
		ELSE TRIM(COALESCE(whatsapp_followup,'Followed Up'))
	END AS whatsapp_followup
FROM bronze.automobile






