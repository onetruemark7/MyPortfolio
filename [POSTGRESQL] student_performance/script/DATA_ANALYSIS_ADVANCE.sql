/*
1. Using fact_performance, dim_major, and dim_dropout_risk, build a dropout risk profile per major. For each major, show the count of students per dropout risk level and compute the percentage share of each risk level within that major. Also include the major's overall average exam_score and average mental_health_rating. Only show majors where the High dropout risk count exceeds 10 students.
*/
WITH dropout_count AS (
	SELECT
		dm.major,
		ddr.dropout_risk,
		COUNT(*) AS number_of_dropout_risk
	FROM gold.fact_performance fp
	JOIN gold.dim_major dm
		ON fp.major_id = dm.major_id
	JOIN gold.dim_dropout_risk ddr
		ON fp.dropout_risk_id = ddr.dropout_risk_id
	GROUP BY
		dm.major,
		ddr.dropout_risk
)
, averages AS (
	SELECT
		dm.major,
		AVG(fp.exam_score) AS average_exam_score,
		AVG(fp.mental_health_rating) AS average_mental_health_rating
	FROM gold.fact_performance fp
	JOIN gold.dim_major dm
		ON fp.major_id = dm.major_id
	GROUP BY
		dm.major
)
SELECT
	dc.major,
	dc.dropout_risk,
	dc.number_of_dropout_risk,
	ROUND((dc.number_of_dropout_risk / NULLIF(SUM(dc.number_of_dropout_risk) OVER(PARTITION BY dc.major),0))*100,2) || '%' AS pct_distribution,
	ROUND(a.average_exam_score,2) AS average_exam_score,
	ROUND(a.average_mental_health_rating,2) AS average_mental_health_rating
FROM dropout_count dc
JOIN averages a
	ON dc.major = a.major
WHERE dc.number_of_dropout_risk > 10;

--=====================================================================================================================
--=====================================================================================================================

/*
2. Using fact_performance and dim_gender, compute a gender performance gap analysis. For each gender, calculate the average exam_score, average study_hours_per_day, and average motivation_level. Then, using window functions, compute the difference of each gender's average exam_score from the overall average exam score across all genders. Rank the genders from highest to lowest average exam_score.
*/

WITH gender_averages AS (
	SELECT
		dg.gender,
		AVG(exam_score) AS average_exam_score,
		AVG(study_hours_per_day) AS average_study_hours_per_day,
		AVG(motivation_level) AS average_motivation_level
	FROM gold.fact_performance fp
	JOIN gold.dim_gender dg
		ON fp.gender_id = dg.gender_id
	GROUP BY dg.gender
)
SELECT
	gender,
	ROUND(average_exam_score,2) AS average_exam_score,
	ROUND(average_study_hours_per_day,2) AS average_study_hours_per_day,
	ROUND(average_motivation_level,2) AS average_motivation_level,
	ROUND(AVG(average_exam_score) OVER(),2) AS overall_average_exam_score,
	ROUND(average_exam_score - AVG(average_exam_score) OVER(),2) AS average_exam_score_difference,
	ROW_NUMBER() OVER(ORDER BY average_exam_score DESC) AS ranking_by_exam_score
FROM gender_averages

--=====================================================================================================================
--=====================================================================================================================

/*
2. Using fact_performance and dim_gender, compute a gender performance gap analysis. For each gender, calculate the average exam_score, average study_hours_per_day, and average motivation_level. Then, using window functions, compute the difference of each gender's average exam_score from the overall average exam score across all genders. Rank the genders from highest to lowest average exam_score.
*/

WITH gender_averages AS (
	SELECT
		dg.gender,
		AVG(exam_score) AS average_exam_score,
		AVG(study_hours_per_day) AS average_study_hours_per_day,
		AVG(motivation_level) AS average_motivation_level
	FROM gold.fact_performance fp
	JOIN gold.dim_gender dg
		ON fp.gender_id = dg.gender_id
	GROUP BY dg.gender
)
SELECT
	gender,
	ROUND(average_exam_score,2) AS average_exam_score,
	ROUND(average_study_hours_per_day,2) AS average_study_hours_per_day,
	ROUND(average_motivation_level,2) AS average_motivation_level,
	ROUND(AVG(average_exam_score) OVER(),2) AS overall_average_exam_score,
	ROUND(average_exam_score - AVG(average_exam_score) OVER(),2) AS average_exam_score_difference,
	ROW_NUMBER() OVER(ORDER BY average_exam_score DESC) AS ranking_by_exam_score
FROM gender_averages;

--=====================================================================================================================
--=====================================================================================================================

/*
3. Using fact_performance, dim_family_income_range, and dim_access_to_tutoring, perform a cross-dimensional analysis. Show the average exam_score for every combination of family income range and tutoring access. Then add a column that flags each combination as 'Above Average' or 'Below Average' based on whether its average exam_score is above or below the overall average exam_score of the entire dataset.
*/
WITH avg_exam_score AS (
	SELECT
		dfir.family_income_range,
		datt.access_to_tutoring,
		AVG(fp.exam_score) AS average_exam_score
	FROM gold.fact_performance fp
	JOIN gold.dim_family_income_range dfir
		ON fp.family_income_range_id = dfir.family_income_range_id
	JOIN gold.dim_access_to_tutoring datt
		ON fp.access_to_tutoring_id = datt.access_to_tutoring_id
	GROUP BY
		dfir.family_income_range,
		datt.access_to_tutoring
)
SELECT
	family_income_range,
	access_to_tutoring AS access_to_tutoring,
	ROUND(average_exam_score,2) AS average_exam_score,
	ROUND((SELECT AVG(exam_score) FROM gold.fact_performance),2) AS overall_avg_exam_score,
	CASE
		WHEN average_exam_score > (SELECT AVG(exam_score) FROM gold.fact_performance) THEN 'Above Average'
		ELSE 'Below Average'
	END AS remarks
FROM avg_exam_score;

--=====================================================================================================================
--=====================================================================================================================

/*
4. Using fact_performance, create a study efficiency score defined as exam_score / NULLIF(study_hours_per_day, 0). Then bucket students into quartiles (Q1, Q2, Q3, Q4) based on this score using NTILE(4). For each quartile, show the average exam_score, average study_hours_per_day, average motivation_level, and average time_management_score.
*/

WITH quartile_ranks AS (
	SELECT
		student_id,
		exam_score,
		study_hours_per_day,
		motivation_level,
		time_management_score,
		exam_score / NULLIF(study_hours_per_day,0) AS effciency_score,
		NTILE(4) OVER(ORDER BY (exam_score / NULLIF(study_hours_per_day,0)))  AS quartiles,
		CASE
			WHEN NTILE(4) OVER(ORDER BY (exam_score / NULLIF(study_hours_per_day,0))) = 1 THEN 'Q1'
			WHEN NTILE(4) OVER(ORDER BY (exam_score / NULLIF(study_hours_per_day,0))) = 2 THEN 'Q2'
			WHEN NTILE(4) OVER(ORDER BY (exam_score / NULLIF(study_hours_per_day,0))) = 3 THEN 'Q3'
		ELSE 'Q4'
	END AS category
	FROM gold.fact_performance
)

SELECt
	category,
	ROUND(AVG(exam_score),2) AS average_exam_score,
	ROUND(AVG(study_hours_per_day),2) AS average_study_hours_per_day,
	ROUND(AVG(motivation_level),2) AS average_motivation_level,
	ROUND(AVG(time_management_score),2) AS average_time_management_score
FROM quartile_ranks
GROUP BY
	category;

--=====================================================================================================================
--=====================================================================================================================

/*
5. Using fact_performance and dim_major, perform a within-major performance ranking. For each student, compute their percentile rank within their major using PERCENT_RANK() based on exam_score. Return only students who fall in the top 10 percentile of their major (i.e., PERCENT_RANK() >= 0.90). Show student_id, major, exam_score, and the computed percentile rank rounded to 4 decimal places.
*/

WITH major_perf AS (
	SELECT
		student_id,
		dm.major,
		fp.exam_score,
		ROUND(
			PERCENT_RANK() OVER(
				PARTITION BY dm.major
				ORDER BY fp.exam_score
				)::NUMERIC
		,4) AS pct_rank
	FROM gold.fact_performance fp
	JOIN gold.dim_major dm
		ON fp.major_id = dm.major_id
)

SELECT
	*
FROM major_perf
WHERE pct_rank >= 0.90;

--=====================================================================================================================
--=====================================================================================================================

/*
6. Using fact_performance, dim_dropout_risk, and dim_study_environment, build a risk-environment matrix. For each combination of study environment and dropout risk level, show the count of students, average exam_score, and average stress_level. Then use a window function to rank each dropout risk level within each study environment by average exam_score descending.
*/

SELECT
	ddr.dropout_risk,
	dse.study_environment,
	COUNT(*) AS number_of_students,
	ROUND(AVG(exam_score),2) AS average_exam_score,
	ROUND(AVG(stress_level),2) AS average_stress_level,
	RANK() OVER(PARTITION BY dse.study_environment ORDER BY AVG(exam_score) DESC) AS rank
FROM gold.fact_performance fp
JOIN gold.dim_dropout_risk ddr
	ON fp.dropout_risk_id = ddr.dropout_risk_id
JOIN gold.dim_study_environment dse
	ON fp.study_environment_id = dse.study_environment_id
GROUP BY
	ddr.dropout_risk,
	dse.study_environment;
	
--=====================================================================================================================
--=====================================================================================================================

/*
7. Using fact_performance, identify consistently struggling students — defined as students who satisfy all three of the following conditions simultaneously: exam_score is below the overall average, mental_health_rating is below the overall average, and motivation_level is below the overall average. For these students, show their student_id, exam_score, mental_health_rating, motivation_level, and stress_level. Then compute the count and percentage of such students out of the total student population.
*/
WITH calc_avg AS (
	SELECT
		AVG(exam_score) AS overall_average_exam_score,
		AVG(mental_health_rating) AS overall_average_mental_health_rating,
		AVG(motivation_level) AS overall_average_motivation_level,
		COUNT(*) AS overall_number_of_students
	FROM gold.fact_performance
)

SELECT
	fp.student_id,
	fp.exam_score, 
	fp.mental_health_rating, 
	fp.motivation_level,
	fp.stress_level,
	ROUND(100*(COUNT(*) OVER()::NUMERIC 
	/ NULLIF(ca.overall_number_of_students::NUMERIC,0)),2) AS pct_distribution
FROM gold.fact_performance fp
CROSS JOIN calc_avg ca
WHERE
	fp.exam_score < ca.overall_average_exam_score
	AND fp.mental_health_rating < ca.overall_average_mental_health_rating
	AND fp.motivation_level < ca.overall_average_motivation_level;
	
--=====================================================================================================================
--=====================================================================================================================

/*
8. Using fact_performance, dim_learning_style, and dim_internet_quality, analyze the interaction effect between learning style and internet quality on exam_score. Show the average exam_score for every combination of learning style and internet quality. Then, for each learning style, use a window function to identify which internet quality level yields the highest average exam_score within that learning style (rank = 1).
*/
WITH rankings AS (
	SELECT
		dls.learning_style,
		diq.internet_quality,
		ROUND(AVG(exam_score),2) AS average_exam_score,
		RANK() OVER(
			PARTITION BY dls.learning_style
			ORDER BY AVG(exam_score) DESC) AS ranking
	FROM gold.fact_performance fp
	JOIN gold.dim_learning_style dls
		ON fp.learning_style_id = dls.learning_style_id
	JOIN gold.dim_internet_quality diq
		ON fp.internet_quality_id = diq.internet_quality_id
	GROUP BY
		dls.learning_style,
		diq.internet_quality
)
SELECT
	*
FROM rankings
WHERE ranking = 1;

--=====================================================================================================================
--=====================================================================================================================

/*
9. Using fact_performance and dim_major, compute rolling statistics across majors ordered alphabetically. For each major, show the average exam_score, and then use window functions to calculate the running average of average_exam_score and the running total count of students as you move across majors alphabetically. Also show the difference between each major's average exam_score and the previous major's average exam_score using LAG().
*/
WITH aggre_avg_count AS (
	SELECT
		dm.major,
		AVG(fp.exam_score) AS average_exam_score,
		COUNT(*) AS number_of_students
	FROM gold.fact_performance fp
	JOIN gold.dim_major dm
		ON fp.major_id = dm.major_id
	GROUP BY dm.major
)

SELECT
	major,
	ROUND(average_exam_score,2) AS average_exam_score,
	ROUND(
		AVG(average_exam_score) OVER(
			ORDER BY major ASC
			ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)
	,2) AS running_avg_exam_score,
	number_of_students,
	ROUND(
		SUM(number_of_students) OVER(
			ORDER BY major ASC
			ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)
	,2) AS running_total_number_of_students,
	ROUND(ABS(average_exam_score - LAG(average_exam_score,1) OVER(ORDER BY major ASC)),2) AS prev_current_difference_avg_exam_score
FROM aggre_avg_count;

--=====================================================================================================================
--=====================================================================================================================

/*
10. Using fact_performance, dim_major, dim_gender, and dim_dropout_risk, build a comprehensive student risk summary. For each combination of major, gender, and dropout risk, show: count of students, average exam_score, average stress_level, and average mental_health_rating. Then add a window-function-based column that shows the cumulative count of students as you move through dropout risk levels (Low → Medium → High) within each major and gender combination. Filter the final result to only show rows where the cumulative count is greater than 5.
*/
WITH aggre_exam_stress_mental AS (
	SELECT
		dm.major,
		dg.gender,
		ddr.dropout_risk,
		COUNT(*) AS number_of_students,
		AVG(exam_score) AS average_exam_score,
		AVG(stress_level) AS average_stress_level,
		AVG(mental_health_rating) AS average_mental_health_rating
	FROM gold.fact_performance fp
	JOIN gold.dim_major dm
		ON fp.major_id = dm.major_id
	JOIN gold.dim_gender dg
		ON fp.gender_id = dg.gender_id
	JOIN gold.dim_dropout_risk ddr
		ON fp.dropout_risk_id = ddr.dropout_risk_id
	GROUP BY
		dm.major,
		dg.gender,
		ddr.dropout_risk
)
SELECT
	major,
	gender,
	dropout_risk,
	number_of_students,
	ROUND(average_exam_score,2) AS average_exam_score,
	ROUND(average_stress_level,2) AS average_stress_level,
	ROUND(average_mental_health_rating,2) AS average_mental_health_rating,
	SUM(number_of_students) OVER(PARTITION BY major, gender ORDER BY number_of_students ASC) AS cumulative_count_of_students
FROM aggre_exam_stress_mental 
ORDER BY SUM(number_of_students) OVER(ORDER BY number_of_students ASC) > 5 ;