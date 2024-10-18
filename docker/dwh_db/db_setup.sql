

CREATE SCHEMA raw_data;
CREATE SCHEMA time;



DROP TABLE IF EXISTS time.day;

CREATE TABLE time.day AS (
    SELECT
        to_char(d, 'YYYYMMDD') ::integer AS day_id,
        date_trunc('day', d) ::date AS date,
        to_char(d, 'Dy, Mon DD YYYY'
) AS day_name,
        extract('year' FROM d
) AS year_id,
        to_char(d, 'YYYY'
) AS year_name,
        extract('isoyear' FROM d
) AS iso_year_id,
        extract('isoyear' FROM d) ::text AS iso_year_name,
        to_char(d, 'YYYYQ') ::smallint AS quarter_id,
        to_char(d, 'YYYY "Q"Q'
) AS quarter_name,
        to_char(d, 'YYYYMM') ::integer AS month_id,
        to_char(d, 'YYYY Mon'
) AS month_name,
        date_trunc('month', d) ::date AS month_start,
        to_char(d, 'IYYYIW') ::integer AS week_id,
        to_char(d, 'IYYY "-" "CW "IW'
) AS week_name,
        date_trunc('week', d) ::date AS week_start,
        CASE WHEN extract(dow FROM d) = 4 THEN
            lag(d, 0) OVER () ::date || ' - ' || lead(d, 6) OVER () ::date
        WHEN extract(dow FROM d) = 5 THEN
            lag(d, 1) OVER () ::date || ' - ' || lead(d, 5) OVER () ::date
        WHEN extract(dow FROM d) = 6 THEN
            lag(d, 2) OVER () ::date || ' - ' || lead(d, 4) OVER () ::date
        WHEN extract(dow FROM d) = 0 THEN
            lag(d, 3) OVER () ::date || ' - ' || lead(d, 3) OVER () ::date
        WHEN extract(dow FROM d) = 1 THEN
            lag(d, 4) OVER () ::date || ' - ' || lead(d, 2) OVER () ::date
        WHEN extract(dow FROM d) = 2 THEN
            lag(d, 5) OVER () ::date || ' - ' || lead(d, 1) OVER () ::date
        WHEN extract(dow FROM d) = 3 THEN
            lag(d, 6) OVER () ::date || ' - ' || lead(d, 0) OVER () ::date
        ELSE
            ''
        END AS reporting_week,
        CASE WHEN extract(dow FROM d) = 4 THEN
            lag(d, 0) OVER () ::date
        WHEN extract(dow FROM d) = 5 THEN
            lag(d, 1) OVER () ::date
        WHEN extract(dow FROM d) = 6 THEN
            lag(d, 2) OVER () ::date
        WHEN extract(dow FROM d) = 0 THEN
            lag(d, 3) OVER () ::date
        WHEN extract(dow FROM d) = 1 THEN
            lag(d, 4) OVER () ::date
        WHEN extract(dow FROM d) = 2 THEN
            lag(d, 5) OVER () ::date
        WHEN extract(dow FROM d) = 3 THEN
            lag(d, 6) OVER () ::date
        ELSE
            NULL
        END AS reporting_week_start,
        CASE WHEN extract(dow FROM d) = 4 THEN
            lead(d, 6) OVER () ::date
        WHEN extract(dow FROM d) = 5 THEN
            lead(d, 5) OVER () ::date
        WHEN extract(dow FROM d) = 6 THEN
            lead(d, 4) OVER () ::date
        WHEN extract(dow FROM d) = 0 THEN
            lead(d, 3) OVER () ::date
        WHEN extract(dow FROM d) = 1 THEN
            lead(d, 2) OVER () ::date
        WHEN extract(dow FROM d) = 2 THEN
            lead(d, 1) OVER () ::date
        WHEN extract(dow FROM d) = 3 THEN
            lead(d, 0) OVER () ::date
        ELSE
            NULL
        END AS reporting_week_end,
        to_char(d, 'ID') ::smallint AS day_of_week_id,
        BTRIM(to_char(d, 'Day')
) AS day_of_week_name,
        to_char(d, 'DD') ::smallint AS day_of_month_id,
        d AS _date
    FROM
        generate_series('2023-01-01'::timestamp, '2029-12-31'::timestamp, '1 day'::interval
) AS d
);

