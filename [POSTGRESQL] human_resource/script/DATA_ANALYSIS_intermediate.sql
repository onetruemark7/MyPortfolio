/*
1.Rank departments by their average salary and assign a rank number — without any ties sharing the same rank.
*/
with aggre_average as (
	select
		department,
		avg(salary) as average_salary
	from gold.dim_job_profile
	group by department
)

select
	department,
	'$' || round(average_salary,2) as average_salary,
	row_number() over(order by average_salary desc) as rank
from aggre_average

--==================================================================================================================
--==================================================================================================================

/*
2. For each employee, calculate their tenure in full years as of today. Then find the average tenure per department.
*/
with years_of_tenure as (
	select
		fr.employeeid,
		jp.department,
		fr.start_date,
		(current_date - fr.start_date) / 365 as years_of_employment
	from gold.fact_records fr
	join gold.dim_job_profile jp
		on fr.job_profile = jp.job_profile
)

select
	department,
	round(avg(years_of_employment),2) as average_year_of_tenure
from years_of_tenure
group by department

--==================================================================================================================
--==================================================================================================================

/*
3. Identify employees who earn more than the average salary of their own department.
*/

with avg_salary_per_dept as (
	select
		department,
		avg(salary) as average_salary
	from gold.dim_job_profile
	group by department
)

select
	de.first_name || ' ' || de.surname as employee_name,
	spd.department,
	jp.salary,
	round(average_salary,2) as average_salary_of_employee_dept
from gold.fact_records fr
join gold.dim_employee de
	on fr.employeeid = de.employeeid
join gold.dim_job_profile jp
	on fr.job_profile = jp.job_profile
join avg_salary_per_dept spd
	on jp.department = spd.department
where salary > spd.average_salary

--==================================================================================================================
--==================================================================================================================

/*
4. Build a workforce diversity summary: for each race/ethnicity group, show the headcount, the percentage of veterans, and the percentage with a disability.
*/
with aggre_categories as (
	select
		race_ethnicity,
		count(veteran) filter(where veteran = 1) as veteran,
		count(veteran) filter(where veteran = 0) as non_veteran,
		count(disability) filter(where disability = 1) as disabled,
		count(disability) filter(where disability = 0) as non_disabled
	from gold.dim_diversity
	group by 
		race_ethnicity
)

select
	race_ethnicity,
	veteran,
	non_veteran,
	(veteran::numeric + non_veteran::numeric) as total_veteran_category,
	disabled,
	non_disabled,
	(disabled::numeric + non_disabled::numeric) as total_disability_category,
	round(((veteran::numeric / (veteran::numeric + non_veteran::numeric))*100),2) || '%' as pct_of_veteran,
	round(((disabled::numeric / (disabled::numeric + non_disabled::numeric))*100),2) || '%' as pct_with_disability
from aggre_categories

--==================================================================================================================
--==================================================================================================================

/*
5. Find the top 3 highest-paid job profiles in each department.
*/
with ranking_salary as (
	select
		department,
		job_profile,
		salary,
		row_number() over(
			partition by department
			order by salary desc
		) as rank
	from gold.dim_job_profile
)

select *
from ranking_salary
where rank < 4

--==================================================================================================================
--==================================================================================================================

/*
6. Compare the number of employees hired each year with the number who left (terminated) that same year. Show the net headcount change per year.
*/
WITH hires AS (
  SELECT
    EXTRACT(YEAR FROM start_date)  AS yr,
    COUNT(*)                       AS hired
  FROM gold.fact_records
  GROUP BY yr
),
terminations AS (
  SELECT
    EXTRACT(YEAR FROM termination_date) AS yr,
    COUNT(*)                            AS terminated
  FROM gold.fact_records
  WHERE active_status = 0
    AND termination_date < '2030-01-01'
  GROUP BY yr
)
SELECT
  COALESCE(h.yr, t.yr)            AS year,
  COALESCE(h.hired, 0)            AS hires,
  COALESCE(t.terminated, 0)       AS terminations,
  COALESCE(h.hired, 0)
    - COALESCE(t.terminated, 0)   AS net_change
FROM hires h
FULL OUTER JOIN terminations t
  ON h.yr = t.yr
ORDER BY year;

--==================================================================================================================
--==================================================================================================================

/*
7. For each office, show the total salary bill and what percentage of the company-wide total salary that office represents.
*/

with sum_total_office as (
	select
		dcol.office,
		sum(djp.salary) as total_salary
	from gold.fact_records fr
	join gold.dim_cost_of_living dcol
		on fr.office_id = dcol.office_id
	join gold.dim_job_profile djp
		on fr.job_profile = djp.job_profile
	group by dcol.office
)

select
	office,
	total_salary,
	round((total_salary / nullif(sum(total_salary) over(),0))* 100,2) || '%' as pct_salary_distribution
from sum_total_office
order by total_salary desc;

--==================================================================================================================
--==================================================================================================================

/*
8. Categorise employees into three salary bands — 'Entry', 'Mid', and 'Senior' — based on where their salary falls relative to the overall salary range. Count how many employees fall into each band.
*/

select
	employee_name,
	salary,
	case rank_by_salary
		when 1 then 'Senior'
		when 2 then 'Mid'
		else 'Entry'
	end as salary_bands
from
	(select
		de. first_name || ' ' || surname as employee_name,
		djp.salary,
		ntile(3) over(order by salary desc) as rank_by_salary
	from gold.fact_records fr
	join gold.dim_job_profile djp
		on fr.job_profile = djp.job_profile
	join gold.dim_employee de
		on fr.employeeid = de.employeeid)

--==================================================================================================================
--==================================================================================================================

/*
9. Which states have both above-average headcount AND above-average average salary compared to all other states?
*/

with avg_salary as (
	select
		ds.state,
		avg(djp.salary) as average_salary,
		count(*) as subtotal_headcount
	from gold.fact_records fr
	join gold.dim_job_profile djp
		on fr.job_profile = djp.job_profile
	join gold.dim_state ds
		on fr.state_id = ds.state_id
	group by ds.state
)

select	
	state,
	round(average_salary,2) as average_salary,
	subtotal_headcount
from avg_salary
where
	subtotal_headcount  > (select avg(subtotal_headcount) from avg_salary)
	and average_salary > (select avg(average_salary) from avg_salary)
order by subtotal_headcount desc;



--==================================================================================================================
--==================================================================================================================

/*
10. For each employee, determine whether they are currently in their first year, second year, third year, or beyond their third year of employment — then show the distribution across these tenure buckets.
*/

with percentile_dist as (
	select
		((current_date - start_date) / 365) as tenured_years,
		(cume_dist() over(order by ((current_date - start_date) / 365))*100)::numeric(10,2) as pct_dist
	from gold.fact_records
)

, employee_count as (
	select
		tenured_years,
		count(*) as number_of_employee
	from percentile_dist
	group by tenured_years
)

select
	tenured_years,
	number_of_employee,
	round(((number_of_employee / sum(number_of_employee) over())*100),2) || '%' as pct_dist
from employee_count
order by pct_dist desc;
