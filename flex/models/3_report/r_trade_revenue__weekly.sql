SELECT
    execution_week_id,
    execution_week_name,
    sum(revenue_net) AS revenue_net,
    sum(quantity) AS trade_volume,
    sum(revenue_net) FILTER (WHERE side = 'sell') AS revenue_net__sell,
    sum(quantity) FILTER (WHERE side = 'sell') AS volume__sell,
    sum(revenue_net) FILTER (WHERE side = 'buy') AS revenue_net__buy,
    sum(quantity) FILTER (WHERE side = 'buy') AS volume__buy
FROM {{ref('trade_fact')}}
GROUP BY
    1,
    2
ORDER BY
    1 DESC
