select * from {{ source('nyc_vio', 'nyc_violations') }}
where lower(violation_category) like '%active%'
