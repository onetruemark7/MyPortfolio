create or replace procedure reload_silver_schema_diversity()
language plpgsql
as
	$$
	begin
		truncate table silver.diversity;
		
		insert into silver.diversity (
			gender,
			gender_identity,
			race_ethnicity,
			veteran,
			disability,
			education,
			sexual_orientation
		)
		
		SELECT
			CASE gender
				WHEN 'male' THEN 'Male'
				WHEN 'female' THEN 'Female'
				ELSE gender
			END AS gender_clean,
		
			CASE gender_identity
				WHEN 'male' THEN 'Male'
				WHEN 'female' THEN 'Female'
				ELSE gender
			END AS gender_identity_clean,
		
			COALESCE(
				NULLIF(
					TRIM(race_ethnicity)
				,'')
			,'Unknown') AS race_ethnicity_clean,
		
			veteran,
		
			disability,
		
			education,
		
			sexual_orientation
		FROM bronze.diversity;
		
		raise notice 'loading silver schema successfully: silver.diversity';
	end
	$$;

-- call reload_silver_schema_diversity()
-- select * from silver.diversity