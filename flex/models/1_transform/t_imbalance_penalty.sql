SELECT
    delivery_start__utc,
    delivery_start__utc at time zone 'Europe/Berlin' AS delivery_start,
    imbalance_penalty__eur_per_mwh,
    imbalance_penalty__eur_per_mwh / 1000 AS imbalance_penalty__eur_per_kwh
FROM {{ref('b_imbalance_penalty')}}
