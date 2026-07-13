/*
1. How many employees are currently active vs. terminated?
*/

select
	active_status,
	count(active_status) as count_of_status
from gold.fact_records
group by active_status

--====================================================================================================
--====================================================================================================

/*
2. What is the average, minimum, and maximum salary per department?

*/

select
	department,
	'$' || min(salary) as minimum_salary,
	'$' || max(salary) as maximum_salary,
	'$' || round(avg(salary),2) as average_salary
from gold.dim_job_profile
group by department;

--====================================================================================================
--====================================================================================================

/*
3. Which office has the highest cost of living?
*/

select
	office,
	cost_of_living_amount
from gold.dim_cost_of_living
where cost_of_living_amount in (select max(cost_of_living_amount) from gold.dim_cost_of_living);

--====================================================================================================
--====================================================================================================

/*
4. How many distinct job titles exist in each department?
*/

select
	department,
	count(distinct job_title) as number_of_job_titles
from gold.dim_job_profile
group by department

--====================================================================================================
--====================================================================================================

/*
5. What is the gender breakdown of the workforce?
*/

select
	gender,
	count(*) as number_of_genders
from gold.dim_diversity
group by gender

--====================================================================================================
--====================================================================================================

/*
6. List all employees hired in the year 2020.
*/

select
	de.first_name || ' ' || de.surname as employee_name,
	de.streetaddress,
	de.zipcode,
	de.city,
	de.date_of_birth,
	fr.start_date
from gold.fact_records fr
join gold.dim_employee de
	on fr.employeeid = de.employeeid
where
	fr.start_date >= '2020-01-01'
	and fr.start_date <= '2020-12-31'

--====================================================================================================
--====================================================================================================

/*
7. Which education level is most common among employees?
*/

select
	education,
	count(education) as count_of_education_per_dept
from gold.dim_diversity
group by education
order by count_of_education_per_dept desc

--====================================================================================================
--====================================================================================================

/*
8. How many employees work in each office type (remote, on-site, hybrid)?
*/

select
	dot.office_type,
	count(*) as number_of_employees_in_office_type
from gold.fact_records fr
join gold.dim_office_type dot
	on fr.office_type_id = dot.office_type_id
group by dot.office_type
order by number_of_employees_in_office_type desc

--====================================================================================================
--====================================================================================================

/*
9. What percentage of employees have a disability on record?
*/

select
	case disability
	when 0 then 'No Disability'
	else 'With Disability'
	end as disability,
	subtotal_number_of_disability,
	round((subtotal_number_of_disability / sum(subtotal_number_of_disability) over())*100,2) || '%' as total_number_of_disability
from
	(select
		disability,
		count(*) as subtotal_number_of_disability
	from gold.dim_diversity
	group by disability)
	
--====================================================================================================
--====================================================================================================

/*
10. Which country has the most employees?
*/

select
	dc.country,
	count(*) as number_of_employees_per_country
from gold.fact_records fr
join gold.dim_country dc
	on fr.country_id = dc.country_id
group by dc.country
order by number_of_employees_per_country desc;
