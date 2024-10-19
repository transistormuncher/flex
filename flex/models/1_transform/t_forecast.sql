SELECT
    delivery_start__utc,
    delivery_start__utc at time zone 'Europe/Berlin' AS delivery_start,
    asset_fk,
    forecast_production__kwh
FROM {{ref('b_forecast')}}
