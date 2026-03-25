-- create table for bronze.col
CREATE TABLE bronze.cost_of_living (
	office VARCHAR,
	col_amount INT,
	currency VARCHAR
);

-- SELECT * FROM bronze.cost_of_living;

--=========================================================================================
--=========================================================================================

-- DROP TABLE bronze.job_profile_mapping;

CREATE TABLE bronze.job_profile_mapping (
	department VARCHAR,
	job_title VARCHAR,
	job_profile VARCHAR,
	compensation VARCHAR,
	level_bonus VARCHAR,
	bonus numeric
);

-- SELECT * FROM bronze.job_profile_mapping;

--=========================================================================================
--=========================================================================================

CREATE TABLE bronze.company_data (
	employeeid INT PRIMARY KEY,
	first_name VARCHAR,
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
	dob date,
	level varchar,
	salary int,
	active_status int,
	job_profile varchar,
	notes varchar
);

-- SELECT * FROM bronze.company_data;

--=========================================================================================
--=========================================================================================

CREATE TABLE bronze.diversity (
	employeeid int,
	gender varchar,
	gender_identity varchar,
	race_ethnicity varchar,
	veteran int,
	disability int,
	education varchar,
	sexual_orientation varchar
);

-- SELECT * FROM bronze.diversity;