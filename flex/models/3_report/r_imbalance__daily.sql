SELECT
    delivery_date,
    asset_fk,
    sum(forecast_delta__kwh) AS forecast_delta__kwh,
    sum(imbalance_penalty) AS imbalance_penalty
FROM {{ref('imbalance_fact')}}
GROUP BY
    1,
    2
ORDER BY
    1 DESC
