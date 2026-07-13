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
FROM bronze.diversity
