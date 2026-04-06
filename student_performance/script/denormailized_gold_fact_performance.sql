-- denormalized fact_performance View
CREATE OR REPLACE VIEW gold.fact_performance_denormalized AS (
	SELECT
		fp.student_id,
		fp.age,
		fp.date_of_birth,
		fp.study_hours_per_day,
		fp.time_management_score,
		fp.exam_score,
		fp.motivation_level,
		fp.social_media_hours,
		fp.netflix_hours,
		fp.screen_time,
		fp.attendance_percentage,
		fp.sleep_hours,
		fp.exercise_frequency,
		fp.previous_gpa,
		fp.semester,
		fp.stress_level,
		fp.exam_anxiety_score,
		fp.mental_health_rating,
		fp.social_activity,
		fp.parental_support_level,
		datt.access_to_tutoring,
		ddls.learning_style,
		ddq.diet_quality,
		ddr.dropout_risk,
		dep.extracurricular_participation,
		dfir.family_income_range,
		dg.gender,
		diq.internet_quality,
		dm.major,
		dpel.parental_education_level,
		dptj.part_time_job,
		dse.study_environment
	FROM gold.fact_performance fp
	JOIN gold.dim_access_to_tutoring datt
		ON fp.access_to_tutoring_id = datt.access_to_tutoring_id
	JOIN gold.dim_learning_style ddls
		ON fp.learning_style_id = ddls.learning_style_id
	JOIN gold.dim_diet_quality ddq
		ON fp.diet_quality_id = ddq.diet_quality_id
	JOIN gold.dim_dropout_risk ddr
		ON fp.dropout_risk_id = ddr.dropout_risk_id
	JOIN gold.dim_extracurricular_participation dep
		ON fp.extracurricular_participation_id = dep.extracurricular_participation_id
	JOIN gold.dim_family_income_range dfir
		ON fp.family_income_range_id = dfir.family_income_range_id
	JOIN gold.dim_gender dg
		ON fp.gender_id = dg.gender_id
	JOIN gold.dim_internet_quality diq
		ON fp.internet_quality_id = diq.internet_quality_id
	JOIN gold.dim_major dm
		ON fp.major_id = dm.major_id
	JOIN gold.dim_parental_education_level dpel
		ON fp.parental_education_level_id = dpel.parental_education_level_id
	JOIN gold.dim_part_time_job dptj
		ON fp.part_time_job_id = dptj.part_time_job_id
	JOIN gold.dim_study_environment dse
		ON fp.study_environment_id = dse.study_environment_id
);


