SELECT
    substring(asset_id, '\d+')::integer AS asset_id,
    asset_id AS asset_reference,
    capacity__kw,
    price_model,
    price__eur_per_mwh,
    fee_model,
    fee__eur_per_mwh,
    fee_percent
FROM
    raw_data.asset
