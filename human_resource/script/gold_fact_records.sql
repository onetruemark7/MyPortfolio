create or replace view gold.fact_records as (
	select
		cd.employeeid,
		djp.job_profile,
		cd.start_date,
		cd.termination_date,
		cd.age,
		dcol.office_id,
		ot.office_type_id,
		ds.state_id,
		dc.country_id,
		dd.employeeid as diversity_id,
		cd.active_status,
		dn.notes_id
	from silver.company_data cd
	join gold.dim_employee de
		on cd.employeeid = de.employeeid
	join gold.dim_job_profile djp
		on cd.job_profile = djp.job_profile
	join gold.dim_state ds
		on cd.state_full = ds.state
	join gold.dim_cost_of_living dcol
		on cd.office = dcol.office
	join gold.dim_country dc
		on cd.country_full = dc.country
	join gold.dim_diversity dd
		on cd.employeeid = dd.employeeid
	join gold.dim_office_type ot
		on cd.office_type = ot.office_type
	join gold.dim_notes dn
		on cd.notes = dn.notes
);

-- select * from gold.fact_records