SELECT
    index::timestamp with time zone AS delivery_start,
    asset_id as asset_fk,
    values  AS forecast_production__kwh
FROM
    raw_data.forecasts
