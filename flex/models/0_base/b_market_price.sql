SELECT
    delivery_start::timestamp with time zone AS delivery_start__utc,
    market_index_price::numeric AS market_price__eur_per_mw
FROM
    raw_data.market_index_price
