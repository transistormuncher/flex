SELECT
    md5({{ref('t_forecast')}}.delivery_start::text || {{ref('t_forecast')}}.asset_fk) AS imbalance_id,
    {{ref('t_forecast')}}.delivery_start,
    {{ref('t_forecast')}}.delivery_start::date AS delivery_date,
    week_id AS delivery_week_id,
    week_name AS delivery_week_name,
    month_id AS delivery_month_id,
    month_name AS delivery_month_name,
    {{ref('t_forecast')}}.asset_fk,
    forecast_production__kwh,
    measured_production__kwh,
    abs(forecast_production__kwh - measured_production__kwh) AS forecast_delta__kwh,
    imbalance_penalty__eur_per_kwh,
    abs(forecast_production__kwh - measured_production__kwh) * imbalance_penalty__eur_per_kwh AS imbalance_penalty
FROM
    {{ref('t_forecast')}}
    LEFT JOIN {{ref('t_measured_production')}} USING (asset_fk, delivery_start)
    LEFT JOIN {{ref('t_imbalance_penalty')}} USING (delivery_start)
    LEFT JOIN time.day ON {{ref('t_forecast')}}.delivery_start::date = day.date
