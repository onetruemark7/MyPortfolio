
CREATE TABLE silver.company_data (
	employeeid int,
	first_name varchar,
	surname varchar,
	streetaddress varchar,
	city varchar,
	state varchar,
	state_full varchar,
	zipcode varchar,
	country varchar,
	country_full varchar,
	age int,
	office varchar,
	start_date date,
	termination_date date,
	office_type varchar,
	department varchar,
	currency varchar,
	bonus_pct numeric,
	job_title varchar,
	date_of_birth date,
	level varchar,
	salary int,
	active_status int,
	job_profile varchar,
	notes varchar
);

-- SELECT * FROM silver.company_data

--==========================================================================================
--==========================================================================================

CREATE TABLE silver.cost_of_living (
	office varchar,
	col_amount int,
	currency varchar
);

-- SELECT * FROM silver.cost_of_living

--==========================================================================================
--==========================================================================================

CREATE TABLE silver.diversity (
	gender varchar,
	gender_identity varchar,
	race_ethnicity varchar,
	veteran int,
	disability int,
	education varchar,
	sexual_orientation varchar
);

-- select * from silver.diversity

--==========================================================================================
--==========================================================================================