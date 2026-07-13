SELECT
	department,

	REPLACE(
		REPLACE(job_title,'"','')
	,',','') AS job_title_clean,

	job_profile,

	REPLACE(
		REPLACE(compensation,'"','')
	,',','')::NUMERIC AS compensation_clean,

	level_bonus,

	bonus
FROM bronze.job_profile_mapping
