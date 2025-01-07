import itemquest/modules/market/sql.{
  type SelectMarketEntriesRow, type SelectMarketRow,
}
import itemquest/web/contexts.{type RequestContext}
import itemquest/web/errors.{type InternalError}

pub fn create_market_entry(
  item_id: Int,
  ctx: RequestContext,
) -> Result(Nil, InternalError(Nil)) {
  use _, _ <- errors.try_query(sql.insert_market_entry(ctx.db, item_id))
  Ok(Nil)
}

pub type SelectMarketError {
  MarketNotFound
}

pub fn select_market(
  market_id: Int,
  ctx: RequestContext,
) -> Result(SelectMarketRow, InternalError(SelectMarketError)) {
  use _, rows <- errors.try_query(sql.select_market(ctx.db, market_id))

  case rows {
    [market] -> Ok(market)
    _ -> MarketNotFound |> errors.Business("Market not found", _) |> Error
  }
}

pub const sort_by_touples = [
  #("price", SortByPrice), #("quantity", SortByQuantity),
]

pub type MarketEntriesSortBy {
  SortByPrice
  SortByQuantity
}

pub type MarketEntriesSearch {
  MarketEntriesSearch(
    market_id: Int,
    sort_by: MarketEntriesSortBy,
    limit: Int,
    offset: Int,
  )
}

pub fn get_market_entries(
  search: MarketEntriesSearch,
  ctx: RequestContext,
) -> Result(List(SelectMarketEntriesRow), InternalError(t)) {
  let sort_by = case search.sort_by {
    SortByPrice -> "price"
    SortByQuantity -> "quantity"
  }

  use _, rows <- errors.try_query(sql.select_market_entries(
    ctx.db,
    search.market_id,
    sort_by,
    search.limit,
    search.offset,
  ))

  Ok(rows)
}
