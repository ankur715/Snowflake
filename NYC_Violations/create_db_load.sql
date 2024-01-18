CREATE DATABASE IF NOT EXISTS Violations;

SELECT * FROM INFORMATION_SCHEMA.COLUMNS;
SELECT * FROM INFORMATION_SCHEMA.DATABASES;

USE Violations;
CREATE SCHEMA IF NOT EXISTS NYC;
SHOW SCHEMAS;
DESCRIBE DATABASE VIOLATIONS;

CREATE TABLE IF NOT EXISTS VIOLATIONS.NYC.NYC_Violations (
    isn_dob_bis_viol VARCHAR(100),
    boro VARCHAR(100),
    bin VARCHAR(100),
    block VARCHAR(100),
    lot VARCHAR(100),
    issue_date VARCHAR(100),
    violation_type_code VARCHAR(100),
    violation_number VARCHAR(100),
    house_number VARCHAR(100),
    street VARCHAR(100),
    device_number VARCHAR(100),
    description VARCHAR(200),
    number VARCHAR(100),
    violation_category VARCHAR(100),
    violation_type VARCHAR(100),
    disposition_date VARCHAR(100),
    disposition_comments VARCHAR(100)
);

CREATE OR REPLACE FILE FORMAT csv_format
    type = CSV
    field_delimiter = ','
    skip_header = 1
    empty_field_as_null = FALSE;

// stage for S3 bucket
CREATE OR REPLACE STAGE VIOLATIONS.NYC.snow_stage 
    url = "s3://nycviolations"
    credentials = (aws_key_id = ''
                   aws_secret_key = '')
    file_format = csv_format;

-- files in the bucket
LIST @VIOLATIONS.NYC.snow_stage;

-- empty created table 
select * from VIOLATIONS.NYC.NYC_Violations;

// copy table from S3 bucket
copy into VIOLATIONS.NYC.NYC_Violations
from @VIOLATIONS.NYC.snow_stage
file_format = (format_name=csv_format)
on_error=continue;

-- S3 table 
select * from VIOLATIONS.NYC.NYC_Violations;

-- delete records to reload using Python
delete from VIOLATIONS.NYC.NYC_Violations;

-- loaded using Snowflake Connector for Python (main.py)
select * from VIOLATIONS.NYC.NYC_Violations;

