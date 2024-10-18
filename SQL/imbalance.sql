WITH preprocess_imbalance AS (
    SELECT
        row_number() OVER () AS imbalance_penalty_id,
        delivery_start::timestamp with time zone AS delivery_start,
        imbalance_penalty AS imbalance_penalty__eur_per_mwh
    FROM
        raw_data.imbalance_penalty
),
preprocess_forecast AS (
    SELECT
        index::timestamp with time zone AS delivery_start,
        asset_id,
    values
        AS forecast_production__kwh
    FROM
        raw_data.forecasts
),
preprocess_measured AS (
    SELECT
        v.asset_id,
        measured.delivery_start::timestamp with time zone AS delivery_start,
        measured_production__kwh
    FROM
        raw_data.measured
        CROSS JOIN LATERAL (
            VALUES ('a1', mp_1),
                ('a2', mp_2),
                ('a3', mp_3),
                ('a4', mp_4)) v (asset_id, measured_production__kwh)
),
imbalance AS (
    SELECT
        preprocess_forecast.delivery_start, preprocess_forecast.asset_id, forecast_production__kwh, measured_production__kwh, forecast_production__kwh - measured_production__kwh AS delta, imbalance_penalty__eur_per_mwh, abs(forecast_production__kwh - measured_production__kwh) * -1 / 1000 * imbalance_penalty__eur_per_mwh AS imbalance_penalty
    FROM
        preprocess_forecast
        LEFT JOIN preprocess_measured ON preprocess_forecast.asset_id = preprocess_measured.asset_id
            AND preprocess_forecast.delivery_start = preprocess_measured.delivery_start
        LEFT JOIN preprocess_imbalance ON preprocess_forecast.delivery_start = preprocess_imbalance.delivery_start
)
SELECT
    delivery_start::date AS date,
    asset_id,
    sum(forecast_production__kwh) AS forecast_production__kwh,
    sum(measured_production__kwh) AS measured_production__kwh,
    sum(abs(delta) * -1) AS imbalance__mwh,
    round(sum(imbalance_penalty)::numeric, 2) AS imbalance_penalty
FROM
    imbalance
GROUP BY
    1,
    2
ORDER BY
    1,
    2
