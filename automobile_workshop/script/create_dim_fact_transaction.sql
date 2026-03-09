
CREATE OR REPLACE VIEW gold.fact_transaction AS (
SELECT
	id , 
	customer_id,
	customer_notes_id,
	customer_type_id,
	complaintid,
	date, 
	parts_cost, 
	service_cost, 
	labour_cost, 
	rating,
	follow_up_date, 
	wait_time_mins, 
	discount_given,
	fleet_name_id,
	fuel_topup_id,
	has_insurance_cover_id,
	home_service_id,
	mechanic_name_id,
	mechanic_notes_id,
	mechanic_skill_level_id,
	parts_replaced_id,
	parts_sourceid,
	payment_mode_id,
	promo_code_used_id,
	referral_source_id,
	remarks_id,
	request_for_pickup_id,
	return_visit_id,
	service_package_id,
	service_priority_id,
	servicetypeid,
	spare_parts_availability_id,
	status_id,
	towing_required_id,
	whatsapp_followup_id,
	workshop_location_id
FROM
(
	SELECT
		ROW_NUMBER() OVER(PARTITION BY dc.customer_id) AS rank_id,
		a.id, 
		dc.customer_id,
		cn.customer_notes_id,
		ct.customer_type_id,
		c.complaintid,
		a.date, 
		a.parts_cost, 
		a.service_cost, 
		a.labour_cost, 
		a.rating,
		a.follow_up_date, 
		a.wait_time_mins, 
		a.discount_given,
		ft.fleet_name_id,
		fut.fuel_topup_id,
		hic.has_insurance_cover_id,
		hs.home_service_id,
		mn.mechanic_name_id,
		mno.mechanic_notes_id,
		msl.mechanic_skill_level_id,
		pr.parts_replaced_id,
		ps.parts_sourceid,
		pm.payment_mode_id,
		pcu.promo_code_used_id,
		rs.referral_source_id,
		r.remarks_id,
		rfp.request_for_pickup_id,
		rv.return_visit_id,
		sp.service_package_id,
		spr.service_priority_id,
		st.servicetypeid,
		spa.spare_parts_availability_id,
		s.status_id,
		tq.towing_required_id,
		wf.whatsapp_followup_id,
		wl.workshop_location_id
	FROM silver.automobile a
	JOIN gold.dim_customer dc
		ON a.customer_id = dc.customer_id
	JOIN gold.dim_customernotes cn
		ON a.customer_notes = cn.customer_notes
	JOIN gold.dim_customertype ct
		ON a.customer_type = ct.customer_type
	JOIN gold.dim_complaint c
		ON a.complaint = c.complaint
	JOIN gold.dim_fleetname ft
		ON a.fleet_name = ft.fleet_name
	JOIN gold.dim_fueltopup fut
		ON a.fuel_topup = fut.fuel_topup
	JOIN gold.dim_hasinsurancecover hic
		ON a.has_insurance_cover = hic.has_insurance_cover
	JOIN gold.dim_homeservice hs
		ON a.home_service = hs.home_service
	JOIN gold.dim_mechanicname mn
		ON a.mechanic_name = mn.mechanic_name
	JOIN gold.dim_mechanicnotes mno
		ON a.mechanic_notes = mno.mechanic_notes
	JOIN gold.dim_mechanicskilllevel msl
		ON a.mechanic_skill_level = msl.mechanic_skill_level
	JOIN gold.dim_partsreplaced pr
		ON a.parts_replaced = pr.parts_replaced
	JOIN gold.dim_partssource ps
		ON a.parts_source = ps.parts_source
	JOIN gold.dim_paymentmode pm
		ON a.payment_mode = pm.payment_mode
	JOIN gold.dim_promocodeused pcu
		ON a.promo_code_used = pcu.promo_code_used
	JOIN gold.dim_referralsource rs
		ON a.referral_source = rs.referral_source
	JOIN gold.dim_remarks r
		ON a.remarks = r.remarks
	JOIN gold.dim_requestforpickup rfp
		ON a.request_for_pickup = rfp.request_for_pickup
	JOIN gold.dim_returnvisit rv
		ON a.return_visit = rv.return_visit
	JOIN gold.dim_servicepackage sp
		ON a.service_package = sp.service_package
	JOIN gold.dim_servicepriority spr
		ON spr.service_priority = spr.service_priority
	JOIN gold.dim_servicetype st
		ON a.service_type = st.service_type
	JOIN gold.dim_sparepartsavailability spa
		ON a.spare_parts_availability = spa.spare_parts_availability
	JOIN gold.dim_status s
		ON a.status = s.status
	JOIN gold.dim_towingrequired tq
		ON a.towing_required = tq.towing_required
	JOIN gold.dim_whatsappfollowup wf
		ON a.whatsapp_followup = wf.whatsapp_followup
	JOIN gold.dim_workshoplocation wl
		ON a.workshop_location = wl.workshop_location
	ORDER BY id ASC
	)m
WHERE rank_id = 1
);