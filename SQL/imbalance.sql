
with preprocess_imbalance as (
    select
                row_number() over () as imbalance_penalty_id,
                delivery_start::timestamp with time zone as delivery_start,
                imbalance_penalty as imbalance_penalty__eur_per_mwh
    from
        base.imbalance_penalty),
     preprocess_forecast as (
         SELECT
             index::timestamp with time zone as delivery_start,
             asset_id,
             values as forecast_production__kwh
         from base.forecasts

     ),
     preprocess_measured as (
         select  v.asset_id,
                 measured.delivery_start::timestamp with time zone as delivery_start,
                 measured_production__kwh
         from base.measured cross join lateral
             (values ('a1', mp_1), ('a2', mp_2), ('a3', mp_3), ('a4', mp_4)
             ) v(asset_id, measured_production__kwh)

     ),
     imbalance as (
         select
             preprocess_forecast.delivery_start,
             preprocess_forecast.asset_id,
             forecast_production__kwh,
             measured_production__kwh,
             forecast_production__kwh - measured_production__kwh as delta,
             imbalance_penalty__eur_per_mwh,
             abs(forecast_production__kwh - measured_production__kwh) * -1 / 1000 * imbalance_penalty__eur_per_mwh as imbalance_penalty
         FROM preprocess_forecast
                  LEFT JOIN preprocess_measured ON preprocess_forecast.asset_id = preprocess_measured.asset_id  AND
                                                   preprocess_forecast.delivery_start = preprocess_measured.delivery_start
                  LEFT JOIN preprocess_imbalance ON preprocess_forecast.delivery_start = preprocess_imbalance.delivery_start
     )

select
    delivery_start::date as date,
    asset_id,
    sum(forecast_production__kwh) as forecast_production__kwh,
    sum(measured_production__kwh) as measured_production__kwh,
    sum(abs(delta) * -1) as imbalance__mwh,
    round(sum(imbalance_penalty)::numeric, 2) as imbalance_penalty
from imbalance
group by 1,2
order by 1,2