import gleam/int
import itemquest/modules/market/submodules/item/sql.{
  type SelectItemPricesRow, type SelectItemSellListingsRow,
  type SelectMarketItemRow,
}
import itemquest/web/contexts.{type RequestContext}
import itemquest/web/errors.{type InternalError}

pub fn create_market_item(
  _item_id: Int,
  _ctx: RequestContext,
) -> Result(Nil, InternalError(Nil)) {
  todo
}

pub type GetMarketItemError {
  ItemNotFoundError
}

pub fn get_item(
  item_id: Int,
  market_id: Int,
  ctx: RequestContext,
) -> Result(SelectMarketItemRow, InternalError(GetMarketItemError)) {
  use _, rows <- errors.try_query(
    sql.select_market_item(ctx.db, item_id, market_id),
    ctx,
  )

  case rows {
    [item, ..] -> Ok(item)
    [] ->
      errors.Business(
        "Item with id: " <> int.to_string(item_id) <> " was not found",
        ItemNotFoundError,
      )
      |> Error
  }
}

pub type PricePeriod {
  Day
  Week
  Month
}

pub fn price_period_from_string(period: String) -> Result(PricePeriod, Nil) {
  case period {
    "day" -> Ok(Day)
    "week" -> Ok(Week)
    "month" -> Ok(Month)
    _ -> Error(Nil)
  }
}

pub fn get_item_prices(
  item_id: Int,
  period: PricePeriod,
  ctx: RequestContext,
) -> Result(List(SelectItemPricesRow), InternalError(Nil)) {
  let interval = case period {
    Day -> "max"
    Week -> "hour"
    Month -> "day"
  }

  use _, rows <- errors.try_query(
    sql.select_item_prices(ctx.db, item_id, interval),
    ctx,
  )

  Ok(rows)
}

pub fn get_item_listings(
  item_id: Int,
  limit: Int,
  offset: Int,
  ctx: RequestContext,
) -> Result(List(SelectItemSellListingsRow), InternalError(Nil)) {
  use _, rows <- errors.try_query(
    sql.select_item_sell_listings(ctx.db, item_id, limit, offset),
    ctx,
  )

  Ok(rows)
}
