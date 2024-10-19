SELECT
    md5(delivery_start::text || asset_fk) AS production_id,
    delivery_start::date AS delivery_date,
    delivery_start,
    asset_fk,
    measured_production__mwh,
    CASE WHEN price_model = 'fixed' THEN
        measured_production__mwh * price__eur_per_mwh
    WHEN price_model = 'market' THEN
        measured_production__mwh * market_price__eur_per_mw
    END AS revenue_generated,
    CASE WHEN fee_model = 'fixed_as_produced' THEN
        measured_production__mwh * fee__eur_per_mwh
    WHEN fee_model = 'fixed_for_capacity' THEN
        capacity__mw * fee__eur_per_mwh
    WHEN fee_model = 'percent_of_market' THEN
        measured_production__mwh * market_price__eur_per_mw * fee_percent
    END AS fee
FROM {{ref('t_measured_production')}}
    LEFT JOIN {{ref('t_asset')}} ON asset_fk = asset_id
    LEFT JOIN {{ref('t_market_price')}} USING (delivery_start)
