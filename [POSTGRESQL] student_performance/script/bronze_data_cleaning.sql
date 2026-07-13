SELECT
	student_id,
	
	age,

	-- artificially inserted column
	((EXTRACT(YEAR FROM CURRENT_DATE) - age)::VARCHAR || '-' || EXTRACT(MONTH FROM CURRENT_DATE)  || '-' || EXTRACT(DAY FROM CURRENT_DATE))::DATE AS date_of_birth, 
	
	CASE gender
		WHEN 'Male' THEN 'Male'
		WHEN 'Female' THEN 'Female'
		ELSE 'Other'
	END AS gender_clean,

	TRIM(major) AS major_clean,

	ROUND(study_hours_per_day,2) AS study_hours_per_day_clean,

	ROUND(social_media_hours,2) AS social_media_hours_clean,

	ROUND(netflix_hours,2) AS netflix_hours_clean,

	TRIM(part_time_job) AS part_time_job_clean,

	ROUND(attendance_percentage,2) AS attendance_percentage_clean,

	ROUND(sleep_hours,2) AS sleep_hours_clean,

	TRIM(diet_quality) AS diet_quality_clean,

	exercise_frequency,

	TRIM(parental_education_level) AS parental_education_level_clean,

	TRIM(internet_quality) AS internet_quality_clean,

	ROUND(mental_health_rating,2) AS mental_health_rating_clean,

	TRIM(extracurricular_participation) AS extracurricular_participation_clean,

	ROUND(previous_gpa,2) AS previous_gpa_clean,

	semester,

	ROUND(stress_level,2) AS stress_level_clean,

	TRIM(dropout_risk) AS dropout_risk_clean,

	social_activity,

	ROUND(screen_time,2) AS screen_time_clean,

	TRIM(study_environment) AS study_environment_clean,

	TRIM(access_to_tutoring) AS access_to_tutoring_clean,

	TRIM(family_income_range) AS family_income_range_clean,

	parental_support_level,

	motivation_level,

	exam_anxiety_score,

	TRIM(learning_style) AS learning_style_clean,

	ROUND(time_management_score,2) AS time_management_score_clean,

	exam_score
FROM bronze.students
ORDER BY student_id;