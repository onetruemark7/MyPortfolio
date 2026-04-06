/*
Create Dim part_time_job in Gold Schema for table and data normalization purposes. Star Schema modeling preparation.
*/

CREATE OR REPLACE VIEW gold.dim_part_time_job AS (
	WITH ptjob_list AS (
	SELECT DISTINCT
	part_time_job
	FROM silver.students
)

SELECT
	'PTJ' || 10 + ROW_NUMBER() OVER(ORDER BY part_time_job) AS part_time_job_id,
	part_time_job,
	ROW_NUMBER() OVER(ORDER BY part_time_job) AS part_time_job_skey
FROM ptjob_list
);

SELECT * FROM gold.dim_part_time_job;