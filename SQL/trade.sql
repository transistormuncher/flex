WITH preprocess_trade AS (
    SELECT
        trade_id,
        side,
        price::numeric AS price,
        quantity::numeric AS quantity,
        CASE WHEN side = 'sell' THEN
            price::numeric * quantity::numeric * -1
        ELSE
            price::numeric * quantity::numeric
        END AS revenue_net,
        execution_time::timestamp with time zone AS execution_time,
        delivery_start::timestamp with time zone AS delivery_start,
        delivery_end
    FROM
        base.trades
)
SELECT
    execution_time::date AS date,
    sum(revenue_net) FILTER (WHERE side = 'sell') AS sell_revenue,
    sum(revenue_net) FILTER (WHERE side = 'buy') buy_revenue,
    sum(revenue_net) AS revenue_net
FROM
    preprocess_trade
GROUP BY
    1
ORDER BY
    1
