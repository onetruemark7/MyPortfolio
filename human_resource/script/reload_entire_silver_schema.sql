create or replace procedure executing_silver_schema()
language plpgsql
as
$$
begin
	call reload_silver_schema();
	call reload_silver_schema_job_profile_mapping();
	call reload_silver_schema_diversity();
	call reload_silver_schema_cost_of_living();
	

	raise notice 'silver tables successfully loaded.';
end
$$;

-- call executing_silver_schema()