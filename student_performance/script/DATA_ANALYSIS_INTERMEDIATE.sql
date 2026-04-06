/*
1. Using fact_performance and dim_major, find the major with the highest average exam_score. Return only the top 1 result.
*/

SELECT
	dm.major,
	ROUND(AVG(exam_score),2) AS average_exam_score
FROM gold.fact_performance fp
JOIN gold.dim_major dm
	ON fp.major_id = dm.major_id
GROUP BY dm.major
ORDER BY average_exam_score DESC
LIMIT 1 ;

--==============================================================================================================
--==============================================================================================================

/*
2. Using fact_performance and dim_dropout_risk, calculate the average mental_health_rating, average stress_level, and average exam_anxiety_score for each dropout risk category.
*/

SELECT
	ddr.dropout_risk,
	ROUND(AVG(mental_health_rating),2) AS average_mental_health_rating,
	ROUND(AVG(stress_level),2) AS average_stress_level,
	ROUND(AVG(exam_anxiety_score),2) AS average_exam_anxiety_score
FROM gold.fact_performance fp
JOIN gold.dim_dropout_risk ddr
	ON fp.dropout_risk_id = ddr.dropout_risk_id
GROUP BY ddr.dropout_risk ;

--==============================================================================================================
--==============================================================================================================

/*
3. Using fact_performance and dim_gender, find the average study_hours_per_day, average social_media_hours, and average netflix_hours for each gender. Also include a computed column for total average screen time (sum of all three averages).
*/

SELECT
	dg.gender,
	ROUND(AVG(study_hours_per_day),2) AS average_study_hours_per_day,
	ROUND(AVG(social_media_hours),2) AS average_social_media_hours,
	ROUND(AVG(netflix_hours),2) AS average_netflix_hours,
	ROUND(
		AVG(study_hours_per_day)  +
		AVG(social_media_hours)  +
		AVG(netflix_hours) 
	,2) AS total_average_screen_time
FROM gold.fact_performance fp
JOIN gold.dim_gender dg
	ON fp.gender_id = dg.gender_id
GROUP BY dg.gender ;

--==============================================================================================================
--==============================================================================================================

/*
4. Using fact_performance and dim_family_income_range, determine which family income range has the highest average exam_score and the highest average previous_gpa. Present both metrics side by side for each income range, sorted by average exam_score descending.
*/

SELECT
	dfir.family_income_range,
	ROUND(AVG(exam_score),2) AS average_exam_score,
	ROUND(AVG(previous_gpa),2) AS average_previous_gpa
FROM gold.fact_performance fp
JOIN gold.dim_family_income_range dfir
	ON fp.family_income_range_id = dfir.family_income_range_id
GROUP BY dfir.family_income_range
ORDER BY average_exam_score DESC ;

--==============================================================================================================
--==============================================================================================================

/*
5. Using fact_performance, identify students who scored above the overall average exam_score. Return their student_id, exam_score, study_hours_per_day, and motivation_level.
*/

SELECT
	student_id, 
	exam_score, 
	study_hours_per_day,
	motivation_level
FROM gold.fact_performance
WHERE exam_score > (SELECT AVG(exam_score) FROM gold.fact_performance);

--==============================================================================================================
--==============================================================================================================

/*
6. Using fact_performance and dim_part_time_job, compare the average sleep_hours, average stress_level, and average study_hours_per_day between students with and without a part-time job.
*/

SELECT
	dptj.part_time_job,
	ROUND(AVG(sleep_hours),2) AS average_sleep_hours,
	ROUND(AVG(stress_level),2) AS average_stress_level,
	ROUND(AVG(study_hours_per_day),2) AS average_study_hours_per_day
FROM gold.fact_performance fp
JOIN gold.dim_part_time_job dptj
	ON fp.part_time_job_id = dptj.part_time_job_id
GROUP BY dptj.part_time_job ;

--==============================================================================================================
--==============================================================================================================

/*
7. Using fact_performance and dim_study_environment, rank each study environment by its average exam_score using a window function. Include the rank, study environment name, and average exam_score in your result.
*/
SELECT
	study_environment,
	ROUND(average_exam_score,2) AS average_exam_score,
	RANK() OVER(ORDER BY average_exam_score DESC) AS ranking
FROM
(SELECT
	dse.study_environment,
	AVG(exam_score) AS average_exam_score
FROM gold.fact_performance fp
JOIN gold.dim_study_environment dse
	ON fp.study_environment_id = dse.study_environment_id
GROUP BY dse.study_environment );

--==============================================================================================================
--==============================================================================================================

/*
8. Using fact_performance and dim_internet_quality, find the percentage distribution of students across each internet quality level. Round the percentage to 2 decimal places.
*/
SELECT
	internet_quality,
	number_of_students,
	ROUND((number_of_students / NULLIF(SUM(number_of_students) OVER(),0))*100,2) AS pct_distribution
FROM
	(SELECT
		diq.internet_quality,
		COUNT(*) AS number_of_students
	FROM gold.fact_performance fp
	JOIN gold.dim_internet_quality diq
		ON fp.internet_quality_id = diq.internet_quality_id
	GROUP BY diq.internet_quality) ;
	
--==============================================================================================================
--==============================================================================================================

/*
9. Using fact_performance and dim_access_to_tutoring, calculate the average exam_score and average previous_gpa for each tutoring access category, and also show the difference between exam_score and previous_gpa averages as a computed column.
*/

SELECT
    datt.access_to_tutoring,
    ROUND(AVG(exam_score),2) AS average_exam_score,
    ROUND(AVG(previous_gpa),2) AS average_previous_gpa,
    ROUND(AVG(exam_score) - AVG(previous_gpa),2) AS score_gpa_difference
FROM gold.fact_performance fp
JOIN gold.dim_access_to_tutoring datt
    ON fp.access_to_tutoring_id = datt.access_to_tutoring_id
GROUP BY datt.access_to_tutoring;
	
--==============================================================================================================
--==============================================================================================================

/*
10. Using fact_performance, bucket students into three sleep_hours groups — Low (less than 6 hours), Moderate (6 to 8 hours), and High (more than 8 hours) — and calculate the average exam_score and average mental_health_rating for each group.
*/

SELECT
	sleep_hours_category,
	ROUND(AVG(exam_score),2) AS average_exam_score,
	ROUND(AVG(mental_health_rating),2) AS average_mental_health_rating
FROM
	(SELECT
		CASE 
			WHEN sleep_hours < 6 THEN 'Low'
			WHEN sleep_hours >= 6 AND sleep_hours <= 8 THEN 'Moderate'
			ELSE 'High'
		END AS sleep_hours_category,
		exam_score,
		mental_health_rating
	FROM gold.fact_performance)
GROUP BY sleep_hours_category ;

--==============================================================================================================
--==============================================================================================================

/*
11. Using fact_performance and dim_major, find the top 3 majors with the lowest average attendance_percentage. For each of those majors, also show their average exam_score.
*/

SELECT
	dm.major,
	ROUND(AVG(attendance_percentage),2) AS average_attendance_percentage,
	ROUND(AVG(exam_score),2) AS average_exam_score
FROM gold.fact_performance fp
JOIN gold.dim_major dm
	ON fp.major_id = dm.major_id
GROUP BY dm.major 
ORDER BY average_attendance_percentage ASC
LIMIT 3;

--==============================================================================================================
--==============================================================================================================

/*
12. Using fact_performance and dim_learning_style, determine which learning style produces the highest average time_management_score and highest average motivation_level. Show all learning styles sorted by average time_management_score descending.
*/

SELECT
	dls.learning_style,
	ROUND(AVG(time_management_score),2) AS average_time_management_score,
	ROUND(AVG(motivation_level),2) AS average_motivation_level
FROM gold.fact_performance fp
JOIN gold.dim_learning_style dls
	ON fp.learning_style_id = dls.learning_style_id
GROUP BY dls.learning_style
ORDER BY average_time_management_score DESC ;

--==============================================================================================================
--==============================================================================================================

/*
13. Using fact_performance and dim_dropout_risk, find the count and percentage of students in the High dropout risk category broken down by dim_gender. Round percentage to 2 decimal places.
*/
WITH high_dropout AS (
    SELECT
        dg.gender,
        COUNT(*) AS number_of_students
    FROM gold.fact_performance fp
    JOIN gold.dim_dropout_risk ddr
        ON fp.dropout_risk_id = ddr.dropout_risk_id
    JOIN gold.dim_gender dg
        ON fp.gender_id = dg.gender_id
    WHERE ddr.dropout_risk = 'High'
    GROUP BY dg.gender
)
SELECT
    gender,
    number_of_students,
    ROUND((number_of_students / NULLIF(SUM(number_of_students) OVER(),0)) * 100,2) AS pct_distribution
FROM high_dropout
ORDER BY number_of_students DESC;

--==============================================================================================================
--==============================================================================================================

/*
14. Using fact_performance, calculate a performance consistency score per student defined as the absolute difference between their exam_score and previous_gpa * 10 (to normalize GPA to a 100-point scale). List the top 10 students with the lowest consistency score (i.e., most consistent performers), showing student_id, exam_score, previous_gpa, and the computed score.
*/

SELECT
    student_id,
    exam_score,
    previous_gpa,
    ROUND(previous_gpa * 10,2) AS hundred_point_scale,
    ROUND(ABS(exam_score - (previous_gpa * 10)),2) AS perf_consistency_score
FROM gold.fact_performance
ORDER BY perf_consistency_score ASC
LIMIT 10;

--==============================================================================================================
--==============================================================================================================

/*
15. Using fact_performance, dim_major, and dim_gender, show the average exam_score for each combination of major and gender. Only include combinations where the average exam_score is above 75. Sort the results by average exam_score descending.
*/

SELECT
	dm.major,
	dg.gender,
	ROUND(AVG(fp.exam_score),2) AS average_exam_score
FROM gold.fact_performance fp
JOIN gold.dim_major dm
	ON fp.major_id = dm.major_id
JOIN gold.dim_gender dg
	ON fp.gender_id = dg.gender_id
GROUP BY
	dm.major,
	dg.gender
HAVING ROUND(AVG(fp.exam_score),2) > 75
ORDER BY average_exam_score DESC;