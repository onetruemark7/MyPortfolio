/*
Consecutive Rating Declines: Identify any mechanic who has had a "rating streak" of at least three consecutive jobs where the customer rating was lower than the rating of their previous job.
*/

WITH sorted_rating_per_mechanic AS (
SELECT
	mechanic_name_id,
	date,
	rating,
	COUNT(DISTINCT id)
FROM gold.fact_transaction
GROUP BY
	mechanic_name_id,
	date,
	rating
)

SELECT
	mechanic_name_id,
	date,
	rating,
	CASE
		WHEN
			LAG(rating,0) OVER(ORDER BY mechanic_name_id, date) < LAG(rating,1) OVER(ORDER BY mechanic_name_id, date)
			AND
			LAG(rating,1) OVER(ORDER BY mechanic_name_id, date) < LAG(rating,2) OVER(ORDER BY mechanic_name_id, date)
				THEN 'Consecutive_Low_Perf'
		ELSE ''
	END AS performance_status
FROM sorted_rating_per_mechanic
WHERE rating::INT != 0
	