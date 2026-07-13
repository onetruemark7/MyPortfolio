/*
Reload/Repopulate contents in silver schema by truncating/emptying the table first before it inserts the latest data.
*/

CREATE OR REPLACE PROCEDURE reload_silver_schema()
LANGUAGE plpgsql
AS $$
BEGIN

    TRUNCATE TABLE silver.company_data;

    INSERT INTO silver.company_data (
        employeeid,
        first_name,
        surname,
        streetaddress,
        city,
        state,
        state_full,
        zipcode,
        country,
        country_full,
        age,
        office,
        start_date,
        termination_date,
        office_type,
        department,
        currency,
        bonus_pct,
        job_title,
        date_of_birth,
        level,
        salary,
        active_status,
        job_profile,
        notes
    )
    SELECT
        employeeid,
        TRIM(first_name),
        TRIM(surname),
        COALESCE(NULLIF(streetaddress, ''), 'Unknown'),
        COALESCE(NULLIF(city, ''), 'Unknown'),
        COALESCE(NULLIF(state, ''), 'Unknown'),
        COALESCE(NULLIF(TRIM(state_full), ''), 'Unknown'),
        TRIM(zipcode),
        TRIM(country),
        TRIM(country_full),
        age,
        REPLACE(REPLACE(REPLACE(REPLACE(
            office,
            'SanFran',  'San Francisco'),
            'SanJose',  'San Jose'),
            'HongKong', 'Hong Kong'),
            'NYC',      'New York City'),
        start_date,
        CASE termination_date
            WHEN '2999-12-12' THEN '2030-01-01'::date
            ELSE termination_date
        END,
        office_type,
        department,
        currency,
        bonus_pct,
        REPLACE(REPLACE(job_title, '"', ''), ',', ''),
        dob,
        TRIM(level),
        salary,
        active_status,
        TRIM(job_profile),
        REPLACE(REPLACE(notes, '"', ''), ',', '')
    FROM bronze.company_data;

    RAISE NOTICE 'Silver schema loaded successfully.';

END;
$$;

-- CALL reload_silver_schema();
-- SELECT * FROM silver.company_data;