SELECT
    INDEX::timestamp with time zone AS delivery_start__utc,
    asset_id AS asset_reference,
    substring(asset_id, '\d+')::integer AS asset_fk,
VALUES
    AS forecast_production__kwh
FROM
    raw_data.forecasts
