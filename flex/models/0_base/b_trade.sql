SELECT
    trade_id,
    side,
    price::numeric AS price,
    quantity::numeric AS quantity,
    execution_time::timestamp with time zone AS execution_time,
    delivery_start::timestamp with time zone AS delivery_start,
    delivery_end
FROM
    raw_data.trades



