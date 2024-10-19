SELECT
    delivery_start::timestamp with time zone AS delivery_start__utc,
    imbalance_penalty::numeric AS imbalance_penalty__eur_per_mwh
FROM
    raw_data.imbalance_penalty
