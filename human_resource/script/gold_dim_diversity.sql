create or replace view gold.dim_diversity as (
	SELECT
		100000 + ROW_NUMBER() OVER() as employeeid,
		gender,
		gender_identity,
		race_ethnicity,
		veteran,
		disability,
		education,
		sexual_orientation
	FROM silver.diversity
);

-- select * from gold.dim_diversity

