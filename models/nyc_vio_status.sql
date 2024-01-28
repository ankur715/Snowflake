with active as (
    select * from {{ ref("stg_nyc_vio_active")}}
),
dismissed as (
    select * from {{ ref("stg_nyc_vio_dismissed")}}
),
resolved as (
    select * from {{ ref("stg_nyc_vio_resolved")}}
)
SELECT
    (select count(*) from active) AS Active_Cnt, 
    (select count(*) from dismissed) AS Dismissed_Cnt, 
    (select count(*) from resolved) AS Resolved_Cnt