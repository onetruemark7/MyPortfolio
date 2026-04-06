/*
1. Using fact_performance and dim_gender, retrieve the total number of students for each gender.
*/

SELECT
	dg.gender,
	COUNT(*) AS number_of_gender
FROM gold.fact_performance fp
JOIN gold.dim_gender dg
	ON fp.gender_id = dg.gender_id
GROUP BY dg.gender
ORDER BY number_of_gender DESC;

--====================================================================================================================================
--====================================================================================================================================

/*
2. Using fact_performance, find the average exam_score of all students.
*/

SELECT
	ROUND(AVG(exam_score),2) AS overall_average_exam_score
FROM gold.fact_performance;

--====================================================================================================================================
--====================================================================================================================================

/*
3. Using fact_performance and dim_major, list each major along with the number of students enrolled in it, sorted from highest to lowest count.
*/

SELECT
	dm.major,
	COUNT(*) AS numbers_of_enrolled
FROM gold.fact_performance fp
JOIN gold.dim_major dm
	ON fp.major_id = dm.major_id
GROUP BY dm.major
ORDER BY numbers_of_enrolled DESC;

--====================================================================================================================================
--====================================================================================================================================

/*
4. Using fact_performance and dim_part_time_job, calculate the average exam_score for students who have a part-time job versus those who do not.
*/

SELECT
	dptj.part_time_job,
	ROUND(AVG(exam_score),2) AS average_score_exam
FROM gold.fact_performance fp
JOIN gold.dim_part_time_job dptj
	ON fp.part_time_job_id = dptj.part_time_job_id
GROUP BY dptj.part_time_job;

--====================================================================================================================================
--====================================================================================================================================

/*
5. Using fact_performance, find the top 10 students with the highest exam_score, showing their student_id, exam_score, and study_hours_per_day.
*/

SELECT
	student_id,
	exam_score,
	study_hours_per_day
FROM gold.fact_performance
ORDER BY exam_score DESC
LIMIT 10;

--====================================================================================================================================
--====================================================================================================================================

/*
6. Using fact_performance and dim_dropout_risk, count how many students fall under each dropout risk category.
*/

SELECT
	ddr.dropout_risk,
	COUNT(*) number_of_dropouts
FROM gold.fact_performance fp
JOIN gold.dim_dropout_risk ddr
	ON fp.dropout_risk_id = ddr.dropout_risk_id
GROUP BY ddr.dropout_risk ;

--====================================================================================================================================
--====================================================================================================================================

/*
7. Using fact_performance, calculate the average sleep_hours grouped by stress_level.
*/

SELECT
	stress_level,
	ROUND(AVG(sleep_hours),2) AS average_sleep_hours
FROM gold.fact_performance
GROUP BY stress_level ;

--====================================================================================================================================
--====================================================================================================================================

/*
8. Using fact_performance and dim_diet_quality, show the average mental_health_rating for each diet quality category.
*/

SELECT
	ddq.diet_quality,
	ROUND(AVG(mental_health_rating),2) AS average_mental_health_rating
FROM gold.fact_performance fp
JOIN gold.dim_diet_quality ddq
	ON fp.diet_quality_id = ddq.diet_quality_id
GROUP BY ddq.diet_quality ;

--====================================================================================================================================
--====================================================================================================================================

/*
9. Using fact_performance, find all students whose attendance_percentage is below 75, and display their student_id, attendance_percentage, and exam_score.
*/

SELECT
	student_id,
	attendance_percentage,
	exam_score
FROM gold.fact_performance
WHERE attendance_percentage < 75 
ORDER BY
	exam_score DESC,
	attendance_percentage DESC ;
	
--====================================================================================================================================
--====================================================================================================================================

/*
10. Using fact_performance and dim_internet_quality, find the average study_hours_per_day for each internet quality level.
*/

SELECT
	diq.internet_quality,
	ROUND(AVG(fp.study_hours_per_day),2) AS average_study_hours_per_day
FROM gold.fact_performance fp
JOIN gold.dim_internet_quality diq
	ON fp.internet_quality_id = diq.internet_quality_id
GROUP BY diq.internet_quality ; 

--====================================================================================================================================
--====================================================================================================================================

/*
11. Using fact_performance and dim_study_environment, determine the average exam_score for each study environment type.
*/

SELECT
    dse.study_environment,
    ROUND(AVG(fp.exam_score),2) AS average_exam_score
FROM gold.fact_performance fp
JOIN gold.dim_study_environment dse
    ON fp.study_environment_id = dse.study_environment_id
GROUP BY dse.study_environment
ORDER BY average_exam_score DESC;

--====================================================================================================================================
--====================================================================================================================================

/*
12. Using fact_performance and dim_learning_style, count the number of students per learning style.
*/

SELECT
	learning_style,
	COUNT(*) number_of_students
FROM gold.fact_performance fp
JOIN gold.dim_learning_style dls
	ON fp.learning_style_id = dls.learning_style_id
GROUP BY learning_style
ORDER BY number_of_students DESC;

--====================================================================================================================================
--====================================================================================================================================

/*
13. Using fact_performance and dim_family_income_range, find the average previous_gpa for each family income range category.
*/

SELECT
	dfir.family_income_range,
	ROUND(AVG(previous_gpa),2) AS average_previous_gpa
FROM gold.fact_performance fp
JOIN gold.dim_family_income_range dfir
	ON fp.family_income_range_id = dfir.family_income_range_id
GROUP BY dfir.family_income_range ;

--====================================================================================================================================
--====================================================================================================================================

/*
14. Using fact_performance, identify students who have a motivation_level of 10 (maximum) and calculate their average exam_score and average time_management_score.
*/

SELECT
	ROUND(AVG(exam_score),2) AS average_exam_score,
	ROUND(AVG(time_management_score),2) AS average_time_management_score
FROM
	(SELECT
		student_id,
		exam_score,
		time_management_score
	FROM gold.fact_performance
	WHERE motivation_level = 10)

--====================================================================================================================================
--====================================================================================================================================

/*
15. Using fact_performance and dim_extracurricular_participation, compare the average exam_score between students who participate in extracurricular activities and those who do not.
*/

SELECT
	dep.extracurricular_participation,
	ROUND(AVG(exam_score),2) AS average_exam_score
FROM gold.fact_performance fp
JOIN gold.dim_extracurricular_participation dep
	ON fp.extracurricular_participation_id = dep.extracurricular_participation_id
GROUP BY dep.extracurricular_participation ;