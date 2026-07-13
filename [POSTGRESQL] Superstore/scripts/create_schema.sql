-- create bronze, silver and gold schema. Bronze serves as the landing schema for Data Ingestion.
-- Silver schema is for Data Manipulation or Data Cleaning.
-- Gold schema is for Data Analysis.
CREATE SCHEMA bronze;

CREATE SCHEMA silver;

CREATE SCHEMA gold;