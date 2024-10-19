SELECT
    trade_id,
    side,
    price::numeric AS price,
    quantity::numeric AS quantity,
    execution_time::timestamp with time zone AS execution_time__utc,
    delivery_start::timestamp with time zone AS delivery_start__utc,
    delivery_end::timestamp with time zone AS delivery_end__utc
FROM
    raw_data.trades
