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
    execution_time,
    delivery_start,
    delivery_end
FROM
    {{ref('b_trade')}}