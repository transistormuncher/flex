SELECT
    month_id,
    month_name,
    asset_fk,
    sum(measured_production__mwh) AS measured_production__mwh,
    round(sum(revenue_generated)::numeric, 2) AS revenue_generated,
    round(sum(fee)::numeric, 2) AS fee,
    round(sum(revenue_generated - fee)::numeric, 2) AS revenue_net,
    round(sum(revenue_generated - fee)::numeric * 0.19, 2) AS vat,
    round(sum(revenue_generated - fee)::numeric * 1.19, 2) AS revenue_gross
FROM {{ref('production_fact')}}
    LEFT JOIN time.day ON delivery_date = day.date
GROUP BY
    1,
    2,
    3
ORDER BY
    1 DESC,
    3 ASC
