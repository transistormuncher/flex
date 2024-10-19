WITH production AS (
    SELECT
        asset_fk,
        sum(measured_production__mwh) AS lifetime_production__mwh,
        sum(measured_production__mwh) FILTER (WHERE date_trunc('month', delivery_date) = date_trunc('month', CURRENT_DATE)) AS production_current_month__mwh,
        round(sum(revenue_generated)::numeric, 2) AS lifetime_revenue_generated,
        round(sum(revenue_generated) FILTER (WHERE date_trunc('month', delivery_date) = date_trunc('month', CURRENT_DATE))::numeric, 2) AS revenue_generated_current_month__mwh
    FROM {{ref('production_fact')}}
GROUP BY
    1
),
imbalance AS (
    SELECT
        asset_fk,
        sum(forecast_delta__kwh) AS lifetime_forecast_delta__kwh,
        sum(forecast_delta__kwh) FILTER (WHERE date_trunc('month', delivery_date) = date_trunc('month', CURRENT_DATE)) AS forecast_delta_current_month__kwh,
        sum(imbalance_penalty) AS lifetime_imbalance_penalty,
        sum(imbalance_penalty) FILTER (WHERE date_trunc('month', delivery_date) = date_trunc('month', CURRENT_DATE)) AS imbalance_penalty_current_month
    FROM {{ref('imbalance_fact')}}
GROUP BY
    1
)
SELECT
    asset_id,
    asset_reference,
    capacity__kw,
    capacity__mw,
    price_model,
    price__eur_per_mwh,
    fee_model,
    fee__eur_per_mwh,
    fee_percent,
    lifetime_production__mwh,
    production_current_month__mwh,
    lifetime_revenue_generated,
    revenue_generated_current_month__mwh,
    lifetime_forecast_delta__kwh,
    forecast_delta_current_month__kwh,
    lifetime_imbalance_penalty,
    imbalance_penalty_current_month
FROM {{ref('t_asset')}}
    LEFT JOIN production ON asset_id = production.asset_fk
    LEFT JOIN imbalance ON asset_id = imbalance.asset_fk
