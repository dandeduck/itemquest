import gleam/bool
import gleam/io
import gleam/result
import gleam/string
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
  #("popularity", SortByPopularity),
]

pub type MarketEntriesSortBy {
  SortByPrice
  SortByQuantity
  SortByPopularity
}

pub type MarketEntriesFilter {
  MarketEntriesFilter(
    market_id: Int,
    search: Result(String, Nil),
    sort_by: MarketEntriesSortBy,
    sort_direction: SortDirection,
    limit: Int,
    offset: Int,
  )
}

pub const sort_direction_touples = [
  #("asc", AscendingSort), #("desc", DescendingSort),
]

pub type SortDirection {
  AscendingSort
  DescendingSort
}

pub fn get_market_query(
  sort_by: MarketEntriesSortBy,
  sort_direction: SortDirection,
  search: Result(String, Nil),
) -> String {
  let sort_by = case sort_by {
    SortByPrice -> "price"
    SortByQuantity -> "quantity"
    SortByPopularity -> "popularity"
  }
  let sort_direction = case sort_direction {
    AscendingSort -> "asc"
    DescendingSort -> "desc"
  }
  let query = "?sort_by=" <> sort_by <> "&sort_direction=" <> sort_direction

  handle_search(search, fn(search) { query <> "&search=" <> search }, fn() {
    query
  })
}

pub fn get_market_entries(
  filter: MarketEntriesFilter,
  ctx: RequestContext,
) -> Result(List(SelectMarketEntriesRow), InternalError(t)) {
  let sort_by = case filter.sort_by {
    SortByPrice -> "price"
    SortByQuantity -> "quantity"
    SortByPopularity -> "popularity"
  }
  let sort_direction = case filter.sort_direction {
    AscendingSort -> "ASC"
    DescendingSort -> "DESC"
  }
  let search =
    handle_search(
      filter.search,
      // todo: check if we need to replace " " with <-> instead
      fn(search) { string.replace(search, each: " ", with: "+") <> ":*" },
      fn() { "" },
    )

  use _, rows <- errors.try_query(sql.select_market_entries(
    ctx.db,
    filter.market_id,
    search,
    sort_by,
    sort_direction,
    filter.limit,
    filter.offset,
  ))

  Ok(rows)
}

fn handle_search(
  search: Result(String, Nil),
  on_set: fn(String) -> t,
  on_empty: fn() -> t,
) -> t {
  case result.unwrap(search, "") != "" {
    True -> {
      let assert Ok(search) = search
      on_set(search)
    }
    _ -> on_empty()
  }
}
