SELECT
            row_number() OVER () AS imbalance_penalty_id,
            delivery_start::timestamp with time zone AS delivery_start,
            imbalance_penalty AS imbalance_penalty__eur_per_mwh
FROM
    raw_data.imbalance_penalty