WITH asset AS (
    SELECT
        replace(asset_id, '_', '') AS asset_id,
        capacity__kw,
        capacity__kw / 1000 AS capacity__mw,
        price_model,
        price__eur_per_mwh,
        fee_model,
        fee__eur_per_mwh,
        fee_percent
    FROM
        raw_data.asset
),
preprocess_measured AS (
    SELECT
        v.asset_id,
        measured.delivery_start::timestamp with time zone AS delivery_start,
        measured_production__kw,
        measured_production__kw / 1000 AS measured_production__mw
    FROM
        raw_data.measured
        CROSS JOIN LATERAL (
            VALUES ('a1', mp_1),
                ('a2', mp_2),
                ('a3', mp_3),
                ('a4', mp_4)) v (asset_id, measured_production__kw)
),
preprocess_market_price AS (
    SELECT
        delivery_start::timestamp with time zone AS delivery_start, market_index_price
    FROM
        raw_data.market_index_price
),
hourly_revenue_and_fee AS (
    SELECT
        delivery_start, asset_id, measured_production__kw, price__eur_per_mwh, market_index_price, CASE WHEN price_model = 'fixed' THEN
            measured_production__mw * price__eur_per_mwh
        WHEN price_model = 'market' THEN
            measured_production__mw * market_index_price
        END AS revenue_generated, CASE WHEN fee_model = 'fixed_as_produced' THEN
            measured_production__mw * fee__eur_per_mwh
        WHEN fee_model = 'fixed_for_capacity' THEN
            capacity__mw * fee__eur_per_mwh
        WHEN fee_model = 'percent_of_market' THEN
            measured_production__mw * market_index_price * fee_percent
        END AS fee
    FROM
        preprocess_measured
        LEFT JOIN asset USING (asset_id)
        LEFT JOIN preprocess_market_price USING (delivery_start))
SELECT
    asset_id,
    round(sum(revenue_generated)::numeric, 2) AS revenue_generated,
    round(sum(fee)::numeric, 2) AS fee,
    round(sum(revenue_generated)::numeric - sum(fee)::numeric, 2) AS revenue_net,
    round((sum(revenue_generated)::numeric - sum(fee)::numeric) * 0.19, 2) AS vat,
    round((sum(revenue_generated)::numeric - sum(fee)::numeric) * 1.19, 2) AS revenue_gross
FROM
    hourly_revenue_and_fee
GROUP BY
    1
ORDER BY
    1
