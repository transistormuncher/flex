SELECT
    trade_id,
    side,
    price,
    quantity,
    revenue_net,
    execution_time,
    delivery_start,
    delivery_end,
    execution.date AS execution_date,
    execution.week_id AS execution_week_id,
    execution.week_name AS execution_week_name,
    execution.month_id AS execution_month_id,
    execution.month_name AS execution_month_name,
    delivery.date AS delivery_date,
    delivery.week_id AS delivery_week_id,
    delivery.week_name AS delivery_week_name,
    delivery.month_id AS delivery_month_id,
    delivery.month_name AS delivery_month_name
FROM {{ref('t_trade')}}
    LEFT JOIN time.day AS execution ON execution_time::date = execution.date
    LEFT JOIN time.day AS delivery ON delivery_start::date = delivery.date
