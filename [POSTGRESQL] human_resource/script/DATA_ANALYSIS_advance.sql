/*
1. Build a rolling 12-month headcount report showing, for each month, how many employees were actively employed at any point during that month.
*/

with aggre_monthly_hired_workers as (
	select
		date_trunc('Month',start_date) as month_date,
		count(*) as number_of_employed_workers
	from gold.fact_records
	where active_status = 1
	group by date_trunc('Month',start_date)
	order by month_date
)

select
	month_date::date,
	number_of_employed_workers,
	sum(number_of_employed_workers)
		over(
			order by month_date
			rows between 11 preceding and current row
		) as running_12month_headcount
from aggre_monthly_hired_workers

--=========================================================================================================
--=========================================================================================================

/*
2. For each department, compute the salary percentile rank of every employee and flag anyone sitting below the 25th percentile (bottom quartile) of their department.
*/
with ntile_ranking as (
	select
		djp.department,
		de.employeeid,
		djp.salary,
		ntile(4) over(
			partition by djp.department
			order by salary desc) as percentile
	from gold.fact_records fr
	join gold.dim_job_profile djp
		on fr.job_profile = djp.job_profile
	join gold.dim_employee de
		on fr.employeeid = de.employeeid
	where fr.active_status = 1
)

select
	nr.department,
	de.first_name || ' ' || de.surname as employee_name,
	nr.salary,
	nr.percentile,
	case nr.percentile
		when 4 then 'Bottom Quartiles'
		else 'Other'
	end bottom_quartiles
from ntile_ranking nr
join gold.dim_employee de
	on nr.employeeid = de.employeeid
where percentile = 4
order by
	salary desc;
	

--=========================================================================================================
--=========================================================================================================

/*
3. Pivot the headcount data so that each row is a department and each column is a country, with the cell value being the number of employees in that department–country combination.
*/

select
	djp.department,
	count(*) filter(where dc.country = 'Hong Kong' ) as number_of_hongkong_employee,
	count(*) filter(where dc.country = 'Japan' ) as number_of_Japan_employee,
	count(*) filter(where dc.country = 'Norway' ) as number_of_norwegian_employee,
	count(*) filter(where dc.country = 'United Kingdom' ) as number_of_uk_employee,
	count(*) filter(where dc.country = 'United States' ) as number_of_usa_employee,
	count(*) as subtotal_employee
from gold.fact_records fr
join gold.dim_job_profile djp
	on fr.job_profile = djp.job_profile
join gold.dim_country dc
	on fr.country_id = dc.country_id
group by djp.department
order by djp.department;

--=========================================================================================================
--=========================================================================================================

/*
4. Calculate the month-over-month percentage change in average salary across the company, using each employee's start_date as the reference point for when their salary 'entered' the workforce.
*/
with overall_salary_per_month as (
	select
		date_trunc('Month', fr.start_date) as date_month,
		avg(djp.salary) as salary_per_month
	from gold.fact_records fr
	join gold.dim_job_profile djp
		on fr.job_profile = djp.job_profile
	where active_status = 1
	group by date_trunc('Month', fr.start_date)
	
)

select
	date_month::date,
	salary_per_month::numeric(10,2) as average_salary_per_month,
	coalesce(
		lag(salary_per_month,1) over(order by date_month)
	,0)::numeric(10,2) as prev_average_salary,
	round(
		(
			(
				(
					salary_per_month::float - lag(salary_per_month,1) over(order by date_month)::float
				) / lag(salary_per_month,1) over(order by date_month)::float
			)*100
		)::numeric
	,2) || '%' as pct_changes
from overall_salary_per_month
order by date_month;

--=========================================================================================================
--=========================================================================================================

/*
5. Identify 'diversity outlier' offices — offices whose gender ratio deviates by more than 20 percentage points from the company-wide gender ratio.
*/
with gender_count as (
	select
		dcol.office,
		dd.gender,
		count(*) as number_of_gender
	from gold.fact_records fr
	join gold.dim_diversity dd
		on fr.employeeid = dd.employeeid
	join gold.dim_cost_of_living dcol
		on fr.office_id = dcol.office_id
	group by
		dd.gender,
		dcol.office
)
, diversity_ratio as (
	select
		office,
		gender,
		number_of_gender,
		sum(number_of_gender) over(partition by office) as total_employees_per_office,
		sum(number_of_gender) filter(where gender = 'Male') over() as total_male_employees,
		sum(number_of_gender) over() as total_gender,
		avg(number_of_gender) filter(where gender = 'Male') over(partition by office) / sum(number_of_gender) over(partition by office) as number_of_average_male_employees,
		(sum(number_of_gender) filter(where gender = 'Male') over() / sum(number_of_gender) over())::numeric(10,2) as overall_male_ratio,
		round(((number_of_gender / nullif(sum(number_of_gender) filter(where gender = 'Male') over(),0))*100),2) as company_diversity_ratio
	from gender_count
)

select
	office,
	gender,
	round(number_of_average_male_employees,2) as number_of_average_male_employees,
	overall_male_ratio,
	company_diversity_ratio as office_male_diversity_ratio
from diversity_ratio
where
	gender != 'Female'
	and company_diversity_ratio > overall_male_ratio + .20
order by office

--=========================================================================================================
--=========================================================================================================

/*
7. For each office, calculate the cost-of-living-adjusted salary — the ratio of average employee salary to the office's cost of living index — and rank offices from most to least 'compensation-efficient'.
*/
with col_per_office as (
	select
		office,
		cost_of_living_amount
	from gold.dim_cost_of_living
)
, avg_salary_per_office as (
	select
		dcol.office,
		avg(djp.salary) as average_salary,
		count(*) as number_of_employees_in_an_office
	from gold.fact_records fr
	join gold.dim_job_profile djp
		on fr.job_profile = djp.job_profile
	join gold.dim_cost_of_living dcol
		on fr.office_id = dcol.office_id
	group by dcol.office
)

select
	aspo.office,
	number_of_employees_in_an_office,
	round(aspo.average_salary,2) as average_salary,
	cpo.cost_of_living_amount,
	round((aspo.average_salary / cpo.cost_of_living_amount),2) as salary_to_col_ratio,
	rank() over(order by (aspo.average_salary / cpo.cost_of_living_amount) desc) as ranking_by_ratio
from avg_salary_per_office as aspo
join col_per_office as cpo
	on aspo.office = cpo.office;
	
--=========================================================================================================
--=========================================================================================================

/*
8. Find all pairs of job profiles that share the same department AND the same seniority level but have a salary gap greater than 20%. Report the gap as a percentage.

Self-join dim_job_profile on matching department and level_bonus (level), then filter for pairs where the higher salary exceeds the lower salary by more than 20%. To avoid duplicate pairs (A-B and B-A), ensure job_profile_a < job_profile_b in the join condition.

*/
with matching_dept_level as (
	select
		a.job_profile as job_profile_a,
		a.department as dept_a,
		a.level as level_a,
		a.salary as salary_a,
		b.job_profile as job_profile_b,
		b.department as dept_b,
		b.level as level_b,
		b.salary as salary_b
	from gold.dim_job_profile a
	join gold.dim_job_profile b
		on a.department = b.department
		and a.level = b.level
		and a.salary > b.salary
		and a.job_profile < b.job_profile
)

select
	job_profile_a,
	dept_a,
	level_a,
	salary_a,
	job_profile_b,
	dept_b,
	level_b,
	salary_b,
	round((((salary_a - salary_b) / ((salary_a + salary_b)/2))*100),2) || '%' as pct_difference
from matching_dept_level
where salary_a > salary_b + (salary_b * .20)
order by pct_difference desc;

--=========================================================================================================
--=========================================================================================================

/*
9. Build a full attrition funnel: for each hire cohort year, show how many employees were hired, how many were still active after 1 year, after 2 years, and after 3 years.
*/

select
	extract(year from start_date) as year_date,
	count(*) filter(where extract( year from age(termination_date, start_date)) = 1) as one_year,
	count(*) filter(where extract( year from age(termination_date, start_date)) = 2) as two_year,
	count(*) filter(where extract( year from age(termination_date, start_date)) = 3) as three_year,
	count(*) filter(where extract( year from age(termination_date, start_date)) > 3) as more_than_three
from gold.fact_records
group by extract(year from start_date)
order by year_date;

--=========================================================================================================
--=========================================================================================================

/*
10. Detect potential pay equity issues: for each department and seniority level combination, compute the salary gap between the highest-paid and lowest-paid employee, and flag combinations where the gap exceeds 30% of the median salary for that group.

Use PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY salary) to compute the median per department-level group. Then compare MAX(salary) - MIN(salary) against 30% of the median. Include the group's headcount, min/max/median salary, the absolute gap, and a flag column. Only include groups with more than 2 employees to avoid noise.
*/
with min_max_calc as (
	select
		djp.department,
		djp.level,
		percentile_cont(0.50) within group (order by djp.salary) as median,
		max(djp.salary) as max_salary,
		min(djp.salary) as min_salary,
		count(*) as headcount
	from gold.fact_records fr
	join gold.dim_job_profile djp
		on fr.job_profile = djp.job_profile
	where active_status = 1
	group by
		djp.department,
		djp.level
)

select
	department,
	level,
	headcount,
	median,
	max_salary,
	min_salary,
	max_salary - min_salary as difference
from min_max_calc
where
	max_salary - min_salary != 0
	and max_salary - min_salary > median * 0.30
	and headcount > 2