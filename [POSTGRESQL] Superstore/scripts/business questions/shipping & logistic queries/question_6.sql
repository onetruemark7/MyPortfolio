-- Shipping and Logistic Question
-- Which shipping methods are associated with customer losses?

with profit_losses as (
    select
        dsm.ship_mode,
        sum(fo.profit) as overall_profit,
        sum(fo.profit) filter ( where fo.profit > 0 )as total_profit_gains,
        sum(fo.profit) filter ( where fo.profit < 0 ) as total_profit_losses,
        round(avg(fo.profit),2) as average_profit,
        count(*) as overall_transaction,
        count(*) filter ( where fo.profit > 0 ) as total_transaction_with_profit_gains,
        count(*) filter ( where fo.profit < 0 ) as total_transaction_with_profit_losses
    from gold.fact_orders fo
    join gold.dim_ship_mode dsm
        on fo.ship_mode_id = dsm.ship_mode_id
    group by dsm.ship_mode
)
, losses_pct as (
    select
        ship_mode,
        sum(total_profit_losses) * 100 / sum(total_profit_gains) as profit_loss_pct,
        sum(total_transaction_with_profit_losses) * 100 / sum(total_transaction_with_profit_gains) as order_transaction_loss_pct
    from profit_losses
    group by ship_mode
)

select
    pl.ship_mode,
    round(lp.profit_loss_pct,2) || '%' as profit_loss_pct,
    round(lp.order_transaction_loss_pct,2) || '%' as order_transaction_loss_pct,
    round(pl.overall_profit,2) as overall_profit,
    round(pl.total_profit_gains,2) as total_profit_gains,
    round(pl.total_profit_losses,2) as total_profit_losses,
    pl.average_profit,
    pl.overall_transaction,
    pl.total_transaction_with_profit_gains,
    pl.total_transaction_with_profit_losses
from profit_losses pl
join losses_pct lp
    on pl.ship_mode = lp.ship_mode
order by profit_loss_pct desc ;