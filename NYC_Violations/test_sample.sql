USE SNOWFLAKE_SAMPLE_DATA;

SELECT * FROM TPCDS_SF100TCL.CUSTOMER
LIMIT 5;

WITH user_birth AS (
        SELECT
            CONCAT(c_salutation, ' ', c_first_name, ' ', c_last_name) AS full_name,
            CONCAT(c_birth_month, '/', c_birth_day, '/', c_birth_year) AS birth_date,
            c_birth_country
        FROM
            TPCDS_SF100TCL.CUSTOMER
    )
SELECT
    c_birth_country birth_country,
    COUNT(full_name) num_people,
    CONCAT(MIN(birth_date), ' - ', MAX(birth_date)) birth_date_range
FROM
    user_birth
GROUP BY
    birth_country
ORDER BY
    num_people DESC;