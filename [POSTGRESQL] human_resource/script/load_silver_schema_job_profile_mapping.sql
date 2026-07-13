create or replace procedure reload_silver_schema_job_profile_mapping()
language plpgsql
as
	$$
	begin
		truncate table silver.job_profile_mapping;

		insert into silver.job_profile_mapping (
			department ,
			job_title ,
			job_profile ,
			compensation ,
			level_bonus ,
			bonus 
		)
		
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
		FROM bronze.job_profile_mapping;
		
		raise notice 'loading silver schema successfully: silver.job_profile_mapping';

	end
	$$;

-- call reload_silver_schema_job_profile_mapping()
-- select * from silver.job_profile_mapping 