/*
Create Fact performance in Gold Schema for table and data normalization purposes. Center table that has one to many relationship with multiple dimension tables.
*/

CREATE OR REPLACE VIEW gold.fact_performance AS (
	SELECT
		student_id,
		age,
		date_of_birth,
		dg.gender_id,
		dm.major_id,
		study_hours_per_day,
		time_management_score,
		exam_score,
		motivation_level,
		dls.learning_style_id,
		
		social_media_hours,
		netflix_hours,
		screen_time,
		dim.internet_quality_id,
		
		dptj.part_time_job_id,
		attendance_percentage,
		
		sleep_hours,
		ddq.diet_quality_id,
		exercise_frequency,
		
		dep.extracurricular_participation_id,
		previous_gpa,
		semester,
		
		stress_level,
		exam_anxiety_score,
		mental_health_rating,
		
		ddr.dropout_risk_id,
		social_activity,
		dse.study_environment_id,
		datt.access_to_tutoring_id,
		
		dpel.parental_education_level_id,
		dfir.family_income_range_id,
		parental_support_level
		
	FROM silver.students s
	JOIN gold.dim_gender dg
		ON s.gender = dg.gender
	JOIN gold.dim_major dm
		ON s.major = dm.major
	JOIN gold.dim_part_time_job dptj
		ON s.part_time_job = dptj.part_time_job
	JOIN gold.dim_diet_quality ddq
		ON s.diet_quality  = ddq.diet_quality
	JOIN gold.dim_parental_education_level dpel
		ON s.parental_education_level = dpel.parental_education_level
	JOIN gold.dim_internet_quality dim
		ON s.internet_quality = dim.internet_quality
	JOIN gold.dim_extracurricular_participation dep
		ON s.extracurricular_participation = dep.extracurricular_participation
	JOIN gold.dim_dropout_risk ddr
		ON s.dropout_risk = ddr.dropout_risk
	JOIN gold.dim_study_environment dse
		ON s.study_environment = dse.study_environment
	JOIN gold.dim_access_to_tutoring datt
		ON s.access_to_tutoring = datt.access_to_tutoring
	JOIN gold.dim_family_income_range dfir
		ON s.family_income_range = dfir.family_income_range
	JOIN gold.dim_learning_style dls
		ON s.learning_style = dls.learning_style
	
	ORDER BY student_id

);

SELECT * FROM gold.fact_performance;