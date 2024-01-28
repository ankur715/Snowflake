USE VIOLATIONS;
USE SCHEMA NYC;

with active as (
    select * from nyc_violations
    where lower(violation_category) like '%active%'
),
dismissed as (
    select * from nyc_violations
    where lower(violation_category) like '%dismissed%'
),
resolved as (
    select * from nyc_violations
    where lower(violation_category) like '%resolved%'
)
SELECT
    (select count(*) from active) AS Active_Cnt, 
    (select count(*) from dismissed) AS Dismissed_Cnt, 
    (select count(*) from resolved) AS Resolved_Cnt;