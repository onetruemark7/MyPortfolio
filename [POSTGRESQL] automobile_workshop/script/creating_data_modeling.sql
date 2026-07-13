SELECT
	mechanic_name ,
	mechanic_skill_level
FROM silver.automobile


SELECT DISTINCT
	whatsapp_followup
FROM silver.automobile;

SELECT
	id , -- fact_transaction
	date , -- fact_transaction
	parts_cost , -- fact_transaction
	service_cost , -- fact_transaction
	labour_cost , -- fact_transaction
	rating , -- fact_transaction
	follow_up_date , -- fact_transaction
	wait_time_mins , -- fact_transaction
	discount_given , -- fact_transaction
	
	customer_id, -- dim_customer DONE
	first_name , -- dim_customer DONE
	last_name , -- dim_customer DONE
	phone , -- dim_customer DONE
	vehicle_type , -- dim_customer DONE
	plate_number , -- dim_customer DONE
	
	service_type , -- dim_servicetype DONE
	complaint , -- dim_complaint  DONE
	parts_replaced , -- dim_partsreplaced DONE
	parts_source ,  -- dim_partssource DONE
	
	mechanic_name , -- dim_mechanic DONE
	mechanic_skill_level , -- dim_mechanic DONE
	
	service_time ,
	service_priority , -- dim_servicepriority DONE
	service_package , -- dim_servicepackage DONE
	
	payment_mode , -- dim_paymentmode DONE
	return_visit , -- dim_returnvisit DONE
	

	remarks , -- dim_remarks DONE
	status , -- dim_status DONE 
	workshop_location , -- dim_workshoplocation DONE
	referral_source , -- dim_referralsource DONE
	
	spare_parts_availability , -- dim_sparepartsavailability DONE

	customer_type , -- dim_customertype DONE
	fleet_name , -- dim_fleetname DONE
	
	fuel_topup , -- dim fuel_topup DONE
	
	promo_code_used , -- dim_promocodeused DONE
	
	has_insurance_cover , -- dim_hasinsurancecover DONE
	mechanic_notes , -- dim_mechanicnotes DONE
	customer_notes , -- dim_customernotes DONE
	request_for_pickup , -- dim_requestforpickup DONE
	home_service ,  -- dim_homeservice DONE
	towing_required , -- dim_towingrequired DONE
	whatsapp_followup -- dim_whatsappfollowedup DONE
FROM silver.automobile;

