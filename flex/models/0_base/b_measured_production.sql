SELECT
    delivery_start::timestamp with time zone AS delivery_start__utc,
    mp_1::numeric mp_1,
    mp_2::numeric mp_2,
    mp_3::numeric mp_3,
    mp_4::numeric mp_4
FROM
    raw_data.measured
