SELECT
    trade_id,
    side,
    price,
    quantity,
    CASE WHEN side = 'sell' THEN
        price::numeric * quantity::numeric * -1
    ELSE
        price::numeric * quantity::numeric
    END AS revenue_net,
    execution_time__utc,
    delivery_start__utc,
    delivery_end__utc,
    execution_time__utc at time zone 'Europe/Berlin' AS execution_time,
    delivery_start__utc at time zone 'Europe/Berlin' AS delivery_start,
    delivery_end__utc at time zone 'Europe/Berlin' AS delivery_end
FROM {{ref('b_trade')}}
