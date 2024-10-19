SELECT
    delivery_start__utc,
    delivery_start__utc at time zone 'Europe/Berlin' AS delivery_start,
    market_price__eur_per_mw
FROM {{ref('b_market_price')}}
