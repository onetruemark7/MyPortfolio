WITH list_pel AS (
SELECT DISTINCT
	parental_education_level -- 5 unique values
FROM gold.fact_performance_denormalized
);

WITH list_major AS (
SELECT DISTINCT
	major -- 6 unique values
FROM gold.fact_performance_denormalized
);

WITH list_se AS (
SELECT DISTINCT
	study_environment -- 5 unique values
FROM gold.fact_performance_denormalized
);

WITH list_iq AS (
SELECT DISTINCT
	internet_quality -- 3 unique values
FROM gold.fact_performance_denormalized
);

WITH list_fir AS (
SELECT DISTINCT
	family_income_range -- 3 unique values
FROM gold.fact_performance_denormalized
);

WITH list_gend AS (
SELECT DISTINCT
	gender -- 3 unique values
FROM gold.fact_performance_denormalized
);

WITH list_dq AS (
SELECT DISTINCT
	diet_quality -- 3 unique values
FROM gold.fact_performance_denormalized
);

WITH list_ls AS (
SELECT DISTINCT
	learning_style -- 4 unique values
FROM gold.fact_performance_denormalized
);

