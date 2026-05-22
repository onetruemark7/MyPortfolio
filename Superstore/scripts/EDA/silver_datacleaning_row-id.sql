-- check for special characters in a field
SELECT
    row_id
FROM silver.superstore
WHERE row_id ~ '[`~!@#$%^&*()-_=+[{]}|\;:,<.>/?"]'

-- checks for null values
SELECT
    row_id
FROM silver.superstore
WHERE row_id IS NULL

--checks for empty string
SELECT
    row_id
FROM silver.superstore
WHERE row_id = ''

--checks for numeric values. expectations: return all rows since the field is varchar in numeric form
SELECT
    row_id
FROM silver.superstore
WHERE row_id ~ '[0-9]'
