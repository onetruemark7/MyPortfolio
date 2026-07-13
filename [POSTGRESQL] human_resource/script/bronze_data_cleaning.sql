SELECT
	employeeid,
	
	TRIM(first_name) AS first_name,

	TRIM(surname) AS surname,

	COALESCE(
		NULLIF(streetaddress,'')
	,'Unknown') AS streetaddress,

	COALESCE(
		NULLIF(city,'')
	,'Unknown') AS city,

	COALESCE(
		NULLIF(state,'')
	,'Unknown') AS state_clean,

	COALESCE(
		NULLIF(
			TRIM(state_full)
		,'')
	,'Unknown') AS state_full_clean,

	TRIM(zipcode) AS zipcode,

	TRIM(country) AS country,

	TRIM(country_full) AS country_full,

	age,

	REPLACE(
		REPLACE(
			REPLACE(
				REPLACE(office,'SanFran','San Francisco')
			,'SanJose','San Jose')
		,'HongKong','Hong Kong')
	,'NYC','New York City') AS office_clean,

	start_date,

	CASE termination_date
		WHEN '2999-12-12' THEN '2030-01-01'
		ELSE termination_date
	END AS termination_date_clean,

	office_type,

	department,

	currency,

	bonus_pct,

	REPLACE(
		REPLACE(job_title,'"','')
	,',','') AS job_title_clean,

	dob,

	TRIM(level) AS level,

	salary,

	active_status,

	TRIM(job_profile) AS job_profile,

	REPLACE(
		REPLACE(notes,'"','')
	,',','') AS notes_clean
FROM bronze.company_data