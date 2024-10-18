SELECT
    v.asset_fk::integer asset_fk,
    delivery_start,
    measured_production__kwh
FROM
    {{ref('b_measured_production')}}
        CROSS JOIN LATERAL (
        VALUES ('1', mp_1),
               ('2', mp_2),
               ('3', mp_3),
               ('4', mp_4)) v (asset_fk, measured_production__kwh)