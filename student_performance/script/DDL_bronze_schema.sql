/*
Creates bronze table for raw data ingestion
*/

CREATE TABLE IF NOT EXISTS bronze.students (
	student_id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
	age INT,
	gender VARCHAR,
	major VARCHAR,
	study_hours_per_day NUMERIC,
	social_media_hours NUMERIC,
	netflix_hours NUMERIC,
	part_time_job VARCHAR,
	attendance_percentage NUMERIC,
	sleep_hours NUMERIC,
	diet_quality VARCHAR,
	exercise_frequency NUMERIC,
	parental_education_level VARCHAR,
	internet_quality VARCHAR,
	mental_health_rating NUMERIC,
	extracurricular_participation VARCHAR,
	previous_gpa NUMERIC,
	semester NUMERIC,
	stress_level NUMERIC,
	dropout_risk VARCHAR,
	social_activity NUMERIC,
	screen_time NUMERIC,
	study_environment VARCHAR,
	access_to_tutoring VARCHAR,
	family_income_range VARCHAR,
	parental_support_level NUMERIC,
	motivation_level NUMERIC,
	exam_anxiety_score NUMERIC,
	learning_style VARCHAR,
	time_management_score NUMERIC,
	exam_score NUMERIC
);

SELECT * FROM bronze.students;