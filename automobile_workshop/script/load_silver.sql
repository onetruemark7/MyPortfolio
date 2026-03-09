
-- TRUNCATE TABLE silver.automobile;
-- SELECT * FROM silver.automobile;

INSERT INTO silver.automobile (
	id ,
	date ,
	customer_id,
	first_name ,
	last_name ,
	phone ,
	vehicle_type ,
	plate_number ,
	service_type ,
	complaint ,
	parts_replaced ,
	mechanic_name ,
	service_cost ,
	payment_mode ,
	return_visit ,
	rating ,
	service_time ,
	remarks ,
	status ,
	workshop_location ,
	referral_source ,
	wait_time_mins ,
	spare_parts_availability ,
	parts_source ,
	service_priority ,
	customer_type ,
	fleet_name ,
	mechanic_skill_level ,
	parts_cost ,
	labour_cost ,
	fuel_topup ,
	discount_given ,
	promo_code_used ,
	follow_up_date ,
	has_insurance_cover ,
	mechanic_notes ,
	customer_notes ,
	request_for_pickup ,
	home_service ,
	towing_required ,
	service_package ,
	whatsapp_followup 
)

SELECT
	CAST(10000 + ROW_NUMBER() OVER(ORDER BY customer_id)AS INT) AS id, -- generated unique id for every rows

	--CAST(SPLIT_PART(date, '/',3) || '-' ||SPLIT_PART(date, '/',2) || '-' || SPLIT_PART(date, '/',1)AS DATE)

	CASE
		WHEN SPLIT_PART(date,'/',1)::INT > 12 AND SPLIT_PART(date,'/',2)::INT <= 12
				THEN TO_DATE(SPLIT_PART(date,'/',3) || '-' ||SPLIT_PART(date,'/',2) || '-' ||SPLIT_PART(date,'/',1),'YYYY-MM-DD')
								
			WHEN SPLIT_PART(date,'/',1)::INT < 12 AND SPLIT_PART(date,'/',2)::INT >= 12
				THEN TO_DATE(SPLIT_PART(date,'/',3) || '-' ||SPLIT_PART(date,'/',1) || '-' ||SPLIT_PART(date,'/',2),'YYYY-MM-DD')
	
			WHEN SPLIT_PART(date,'/',1)::INT <= 12 AND SPLIT_PART(date,'/',2)::INT <= 12
				THEN TO_DATE(SPLIT_PART(date,'/',3) || '-' ||SPLIT_PART(date,'/',2) || '-' ||SPLIT_PART(date,'/',1),'YYYY-MM-DD')
	
			WHEN SPLIT_PART(date,'/',1)::INT <= 12 AND SPLIT_PART(date,'/',2)::INT > 12
				THEN TO_DATE(SPLIT_PART(date,'/',3) || '-' ||SPLIT_PART(date,'/',1) || '-' ||SPLIT_PART(date,'/',2),'YYYY-MM-DD')
			ELSE TO_DATE(date,'YYYY-MM-DD')
	END AS date,

	customer_id,

	INITCAP(
		LOWER(
			SPLIT_PART(customer_name,' ', 1)
			)
		) AS first_name,

	INITCAP(
		LOWER(
			SPLIT_PART(customer_name,' ', 2)
			)
		) AS last_name,

	phone::VARCHAR(20) AS phone,
	TRIM(vehicle_type) AS vehicle_type,
	TRIM(plate_number) AS plate_number,
	TRIM(service_type) AS service_type,
	CASE
		WHEN complaint ILIKE '%brake%' THEN 'Brake Failure'
		WHEN complaint ILIKE '%eng%' OR complaint ILIKE '%enj%' THEN 'Engine Knocking'
		WHEN complaint ILIKE '%oil%' THEN 'Oil Change'
		WHEN complaint ILIKE '%suspe%' THEN 'Suspension Noise'
		ELSE COALESCE(complaint,'Unknown')
	END AS complaint,
	parts_replaced,
	COALESCE(mechanic_name,'Other') AS mechanic_name,
	service_cost,
	CASE
		WHEN payment_mode ILIKE '%trans%' THEN 'Transfer'
		WHEN payment_mode ILIKE '%cash%' THEN 'Cash'
		WHEN payment_mode ILIKE '%pos%' THEN 'POS'
		ELSE TRIM(payment_mode)
	END AS payment_mode,

	return_visit::VARCHAR(10),
	COALESCE(rating, 0) AS rating,
	
	(
        -- 1. Take the floor as 'hours'
        (FLOOR(service_time) || ' hours')::interval + 
        -- 2. Take the decimal remainder * 100 as 'minutes'
        ((MOD(service_time, 1) * 100) || ' minutes')::interval +
        -- 3. Add 12 hours for PM (if applicable)
        '12 hours'::interval
    )::time AS service_time,
	
	COALESCE(remarks,'Other') AS remarks,
	status,
	COALESCE(
		REGEXP_REPLACE(
			REGEXP_REPLACE(workshop_location,'(?i)main.*','Main Bay','g')
		,'VIP.*','VIP Section','g')
	,'Random Area')::VARCHAR AS workshop_location,

	TRIM(
		REGEXP_REPLACE(
				REGEXP_REPLACE(referral_source, '^.*whats.*$', 'Whatsapp', 'i')
			,'^.*mechani.*$','Mechanic Referral','i'
		)
	) AS referral_source,

	COALESCE(
		REGEXP_REPLACE(wait_time_mins,'[A-Za-z]','','g')::INT
	,30) AS wait_time_mins,

	TRIM(
		REGEXP_REPLACE(
			REGEXP_REPLACE(spare_parts_availability,'^.*ord.*$','Ordered','i')
		,'^avai.*$','Available','i') 
	) AS spare_parts_availability,

	REGEXP_REPLACE(
		REGEXP_REPLACE(
			REGEXP_REPLACE(parts_source,'^.*mkt$','Ladipo Market','i')
		,'^.*benz.*$','Benz Supply','i')
	,'^.*customer.*$','From Customer','i') AS parts_source,

	TRIM(
		REGEXP_REPLACE(
			REGEXP_REPLACE(service_priority,'^.*emer.*$','Emergency','i')
		,'^.*norm.*$','Normal','i')
	) AS service_priority,

	TRIM(
		REGEXP_REPLACE(customer_type,'^first.*$','First Timer','i')
	) AS customer_type,

	TRIM(
		COALESCE(
			REGEXP_REPLACE(
				REGEXP_REPLACE(fleet_name,'^govt.*$','Government Convoy','i')
			,'^.*co$','Logistics Company','i')
		,'Private')
	) AS fleet_name,

	TRIM(
		COALESCE(
			REGEXP_REPLACE(
				REGEXP_REPLACE(mechanic_skill_level,'^sen.*$','Senior','i')
			,'^special.*$','Specialist','i')
		,'Junior')
	)AS mechanic_skill_level,

	COALESCE(
		REGEXP_REPLACE(parts_cost,'^.*[:alpha:].*$','0','i')::INT
	,0) AS parts_cost,
	
	COALESCE(
		REGEXP_REPLACE(labour_cost,'k','000','i')::INT
	,15000) AS labour_cost,

	CASE
		WHEN fuel_topup ILIKE '%no%' THEN 'No'
		WHEN fuel_topup ILIKE '%yes%' THEN 'Yes'
		ELSE COALESCE(fuel_topup,'Unknown')
	END AS fuel_topup,

	COALESCE(
		REGEXP_REPLACE(discount_given,'k','000','i')::INT
	,0) AS discount_given,

	CASE
		WHEN promo_code_used IS NULL OR promo_code_used ILIKE '%n/a%' THEN 'Unknown'
		ELSE TRIM(INITCAP(LOWER(promo_code_used)))
	END AS promo_code_used,

	CASE
		WHEN SPLIT_PART(follow_up_date,'/',1)::INT > 12 AND SPLIT_PART(follow_up_date,'/',2)::INT <= 12
				THEN TO_DATE(SPLIT_PART(follow_up_date,'/',3) || '-' ||SPLIT_PART(follow_up_date,'/',2) || '-' ||SPLIT_PART(follow_up_date,'/',1) ,'YYYY-MM-DD')
								
			WHEN SPLIT_PART(follow_up_date,'/',1)::INT < 12 AND SPLIT_PART(follow_up_date,'/',2)::INT >= 12
				THEN TO_DATE(SPLIT_PART(follow_up_date,'/',3) || '-' ||SPLIT_PART(follow_up_date,'/',1) || '-' ||SPLIT_PART(follow_up_date,'/',2) ,'YYYY-MM-DD')
	
			WHEN SPLIT_PART(follow_up_date,'/',1)::INT <= 12 AND SPLIT_PART(follow_up_date,'/',2)::INT <= 12
				THEN TO_DATE(SPLIT_PART(follow_up_date,'/',3) || '-' ||SPLIT_PART(follow_up_date,'/',2) || '-' ||SPLIT_PART(follow_up_date,'/',1) ,'YYYY-MM-DD')
	
			WHEN SPLIT_PART(follow_up_date,'/',1)::INT <= 12 AND SPLIT_PART(follow_up_date,'/',2)::INT > 12
				THEN TO_DATE(SPLIT_PART(follow_up_date,'/',3) || '-' ||SPLIT_PART(follow_up_date,'/',1) || '-' ||SPLIT_PART(follow_up_date,'/',2) ,'YYYY-MM-DD')
			ELSE TO_DATE(COALESCE(follow_up_date,'1970-01-01') ,'YYYY-MM-DD') -- with 1970-01-01 as value, its the baseline for no records
	END AS follow_up_date,

	CASE
		WHEN has_insurance_cover ILIKE '%no%' THEN 'No'
		WHEN has_insurance_cover ILIKE '%yes%' THEN 'Yes'
		ELSE TRIM(COALESCE(has_insurance_cover,'Unknown'))
	END has_insurance_cover,

	COALESCE(mechanic_notes, 'Follow standard procedure') AS mechanic_notes,

	CASE
		WHEN customer_notes ILIKE '%no complain%' THEN 'No Complain'
		ELSE COALESCE(customer_notes, 'No Complain')
	END AS customer_notes,

	CASE
		WHEN request_for_pickup ILIKE '%y%' THEN 'Yes'
		WHEN request_for_pickup ILIKE '%n%' THEN 'No'
		ELSE COALESCE(request_for_pickup,'To be asked')
	END AS request_for_pickup,

	CASE
		WHEN home_service ILIKE '%no%' OR home_service ILIKE '%n%' THEN 'No'
		WHEN home_service ILIKE '%yes%' OR home_service ILIKE '%y%' THEN 'Yes'
		ELSE 'To be asked'
	END AS home_service,

	COALESCE(towing_required,'To be asked') AS towing_required,

	COALESCE(
		REGEXP_REPLACE(
			REGEXP_REPLACE(service_package,'.*gold.*','Gold Maintenance Plan','i')
		,'.*one.*','One Time','i')
	,'One Time') AS service_package,

	CASE
		WHEN whatsapp_followup ILIKE '%y%' OR whatsapp_followup ILIKE '%yes%' THEN 'Yes'
		WHEN whatsapp_followup ILIKE '%n%' OR whatsapp_followup ILIKE '%no%' THEN 'No'
		WHEN whatsapp_followup ILIKE '%followed up%' THEN 'Followed Up'
		ELSE TRIM(COALESCE(whatsapp_followup,'Followed Up'))
	END AS whatsapp_followup
	
FROM bronze.automobile
ORDER BY id;

