

with preprocess_trade as (
    select
        trade_id,
        side,
        price::numeric as price,
        quantity::numeric as quantity,
        CASE WHEN side = 'sell'
                 THEN price::numeric * quantity::numeric * -1
             ELSE price::numeric * quantity::numeric END AS revenue_net,
        execution_time::timestamp with time zone as execution_time,
        delivery_start::timestamp with time zone as delivery_start,
        delivery_end
    from base.trades)

select
    execution_time::date as date,
    sum(revenue_net) filter ( where side='sell' ) as sell_revenue,
    sum(revenue_net) filter ( where side='buy' ) buy_revenue,
    sum(revenue_net) as revenue_net
from preprocess_trade
GROUP by 1
order by 1