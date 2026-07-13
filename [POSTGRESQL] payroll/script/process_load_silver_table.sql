-- SELECT * FROM silver.payroll LIMIT 3000

INSERT INTO silver.payroll (
	id   ,
	first_name ,
	last_name ,
	mid_init ,
	name_suffix ,
	agency_start_date ,
	work_borough_location ,
	title_description ,
	leave_status_as_of_june30 ,
	base_salary ,
	pay_basis ,
	regular_hours ,
	regular_gross_paid ,
	ot_hours ,
	ot_hours_paid ,
	total_other_pay ,
	created_at 
)

SELECT

	'PR' || ROW_NUMBER() OVER()::TEXT AS id,

	TRIM(
		INITCAP(
			LOWER(
				REGEXP_REPLACE(first_name, '0','o','i')
			)
		)
	)::TEXT AS first_name_clean,

	INITCAP(
		LOWER(
			TRIM(
				REGEXP_REPLACE(
					REGEXP_REPLACE(
						REGEXP_REPLACE(
							REGEXP_REPLACE(
								REGEXP_REPLACE(
									REGEXP_REPLACE(
										REGEXP_REPLACE(last_name,'(Jr$|\sJr\s|\sJr\sJr$|\sJr\sII$)','','i') -- removes 'Jr' and its redundancies
									,'(Sr$|\sSr\s|\sSr\sSr$)','','i') -- removes 'Sr' and its redundancies
								,'\m(II|\mII\m|2nd)$','','i') -- removes '2nd or II' and its redundancies
							,'(\miii$|\m3rd$|\m3rd\siii$|\m111$)','','i') -- removes '3rd or III' and its redundancies
						,'(\mIV$|\miv\siv$|4th$)','','i') -- removes '4th or iv' and its redundancies
					,'(\mv$|\sv\sv$|5$|5th$)','','i')  -- removes '5th or V' and its redundancies
				,'(\mVI$|6$|6th$)','','i') -- removes '6th or VI' and its redundancies
			)
		)
	) AS last_name_clean,

	CASE
		WHEN mid_init ~ '[0-9]' OR mid_init ~ '^[-"&(./_`<=]$' THEN NULL
		WHEN mid_init ~ '[A-Za-z]' THEN UPPER(TRIM(mid_init))
		WHEN mid_init IS NULL THEN '[N/A]'
		ELSE mid_init
	END::TEXT AS mid_init_clean,

	CASE
		WHEN last_name ~* '(Jr$|\sJr\s|\sJr\sJr$|\sJr\sII$)' THEN 'Jr.'
		WHEN last_name ~* '(Sr$|\sSr\s|\sSr\sSr$)' THEN 'Sr.'
		WHEN last_name ~* '\m(II|\mII\m|2nd)$' THEN 'II'
		WHEN last_name ~* '(\miii$|\m3rd$|\m3rd\siii$|\m111$)' THEN 'III'
		WHEN last_name ~* '(\mIV$|\miv\siv$|4th$)' THEN 'IV'
		WHEN last_name ~* '(\mv$|\sv\sv$|5$|5th$)' THEN 'V'
		WHEN last_name ~* '(\mVI$|6$|6th$)' THEN 'VI'
		ELSE '[N/A]'
	END AS name_suffix,

	COALESCE(agency_start_date,'1000-01-01') AS agency_start_date,

	COALESCE(
		INITCAP(
			LOWER(
				TRIM(
					REGEXP_REPLACE(
						REGEXP_REPLACE(
							REGEXP_REPLACE(
								REGEXP_REPLACE(work_location_borough,'bronx','Bronx','i')
							,'manhattan','Manhattan','i')
						,'queens','Queens','i')
					,'richmond','Richmond','i')
				)
			)
		)
	,'Other') work_location_borough_clean,

	COALESCE(title_description,'Other') AS title_description_clean,

	INITCAP(
		LOWER(
			TRIM(leave_status_as_of_june_30)
		)
	) AS leave_status_as_of_june_30_clean,

	REPLACE(
		REPLACE(base_salary,'$','')
	,',','')::NUMERIC(10,2) AS base_salary_clean,

	TRIM(pay_basis) AS pay_basis_clean,

	REPLACE(
		REPLACE(regular_hours,'-','')
	,',','')::NUMERIC(10,2) AS regular_hours_clean,

	REPLACE(
		REPLACE(
			REPLACE(regular_gross_paid,'$','')
		,',','')
	,'-','')::NUMERIC(10,2) AS regular_gross_paid_clean,

	REPLACE(
		REPLACE(ot_hours,'-','')
	,',','')::NUMERIC(10,2) AS ot_hours_clean,

	REPLACE(
		REPLACE(
			REPLACE(total_ot_paid,'$','')
		,'-','')
	,',','')::NUMERIC(10,2) AS total_ot_paid_clean,

	REPLACE(
		REPLACE(
			REPLACE(total_other_pay,'$','')
		,'-','')
	,',','')::NUMERIC(10,2) AS total_other_pay_clean,

	NOW()::TIMESTAMPTZ AS created_at
FROM bronze.payroll