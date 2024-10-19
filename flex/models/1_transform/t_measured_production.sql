SELECT
    v.asset_fk::integer asset_fk,
    delivery_start__utc,
    delivery_start__utc at time zone 'Europe/Berlin' AS delivery_start,
    measured_production__kwh,
    measured_production__kwh / 1000 AS measured_production__mwh
FROM {{ref('b_measured_production')}}
    CROSS JOIN LATERAL (
        VALUES ('1', mp_1),
            ('2', mp_2),
            ('3', mp_3),
            ('4', mp_4)) v (asset_fk, measured_production__kwh)
