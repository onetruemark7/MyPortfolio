create or replace view gold.dim_job_profile as (
	select
	job_profile as job_profile_id,
	job_title,
	department,
	compensation as salary,
	level_bonus as level,
	bonus as bonus_pct
from silver.job_profile_mapping
);


-- select * from gold.dim_job_profile