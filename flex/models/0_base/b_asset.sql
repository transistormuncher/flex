SELECT
    substring(asset_id, '\d+')::integer as asset_id,
    asset_id as asset_reference,
    capacity__kw,
    capacity__kw / 1000 AS capacity__mw,
    price_model,
    price__eur_per_mwh,
    fee_model,
    fee__eur_per_mwh,
    fee_percent
FROM
    raw_data.asset