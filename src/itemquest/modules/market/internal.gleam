import gleam/int
import gleam/list
import gleam/result
import gleam/string
import gleam/uri
import itemquest/modules/market/sql.{
  type SelectMarketItemsRow, type SelectMarketRow,
}
import itemquest/web/contexts.{type RequestContext}
import itemquest/web/errors.{type InternalError}

pub type SelectMarketError {
  MarketNotFound
}

pub fn select_market(
  market_id: Int,
  ctx: RequestContext,
) -> Result(SelectMarketRow, InternalError(SelectMarketError)) {
  use _, rows <- errors.try_query(sql.select_market(ctx.db, market_id), ctx)

  case rows {
    [market] -> Ok(market)
    _ -> MarketNotFound |> errors.Business("Market not found", _) |> Error
  }
}

pub type MarketSortBy {
  SortByPrice
  SortByQuantity
  SortByPopularity
}

pub fn sort_by_from_string(sort_by: String) -> Result(MarketSortBy, Nil) {
  case sort_by {
    "price" -> Ok(SortByPrice)
    "quantity" -> Ok(SortByQuantity)
    "popularity" -> Ok(SortByPopularity)
    _ -> Error(Nil)
  }
}

pub fn sort_by_to_string(sort_by: MarketSortBy) -> String {
  case sort_by {
    SortByPrice -> "price"
    SortByQuantity -> "quantity"
    SortByPopularity -> "popularity"
  }
}

pub type MarketItemsFilter {
  MarketItemsFilter(
    market_id: Int,
    search: Result(String, Nil),
    sort_by: MarketSortBy,
    sort_direction: SortDirection,
    limit: Int,
    offset: Int,
  )
}

pub type SortDirection {
  AscendingSort
  DescendingSort
}

pub fn sort_direction_from_string(
  sort_direction: String,
) -> Result(SortDirection, Nil) {
  case sort_direction {
    "asc" -> Ok(AscendingSort)
    "desc" -> Ok(DescendingSort)
    _ -> Error(Nil)
  }
}

pub fn sort_direction_to_string(sort_direction: SortDirection) -> String {
  case sort_direction {
    AscendingSort -> "asc"
    DescendingSort -> "desc"
  }
}

pub fn get_market_query(filter: MarketItemsFilter) -> String {
  let query = [
    #("sort_by", sort_by_to_string(filter.sort_by)),
    #("sort_direction", sort_direction_to_string(filter.sort_direction)),
    #("offset", int.to_string(filter.offset)),
    #("limit", int.to_string(filter.limit)),
  ]

  let search_addition =
    handle_search(filter.search, fn(search) { [#("search", search)] }, list.new)

  "?"
  <> list.flatten([query, search_addition])
  |> uri.query_to_string
}

pub fn get_market_items(
  filter: MarketItemsFilter,
  ctx: RequestContext,
) -> Result(#(Int, List(SelectMarketItemsRow)), InternalError(Nil)) {
  let search = handle_search(filter.search, name_query, fn() { "" })

  use count, rows <- errors.try_query(
    sql.select_market_items(
      ctx.db,
      filter.market_id,
      search,
      filter.sort_by |> sort_by_to_string,
      filter.sort_direction |> sort_direction_to_string |> string.uppercase,
      filter.limit,
      filter.offset,
    ),
    ctx,
  )

  Ok(#(count, rows))
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

pub fn search_market_item_names(
  market_id: Int,
  search: String,
  ctx: RequestContext,
) -> Result(List(String), InternalError(Nil)) {
  use _, rows <- errors.try_query(
    sql.select_market_item_names(ctx.db, market_id, name_query(search)),
    ctx,
  )

  rows
  |> list.map(fn(row) { row.name })
  |> Ok
}

fn name_query(search: String) {
  // todo: check if we need to replace " " with <-> instead
  string.replace(search, each: " ", with: "+") <> ":*"
}
