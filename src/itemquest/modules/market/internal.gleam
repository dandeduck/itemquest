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

pub fn create_market_item(
  _item_id: Int,
  _ctx: RequestContext,
) -> Result(Nil, InternalError(Nil)) {
  todo
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

pub type MarketSortBy {
  SortByPrice
  SortByQuantity
  SortByPopularity
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

pub const sort_direction_touples = [
  #("asc", AscendingSort), #("desc", DescendingSort),
]

pub type SortDirection {
  AscendingSort
  DescendingSort
}

pub fn sort_direction_to_string(sort_direction: SortDirection) -> String {
  case sort_direction {
    AscendingSort -> "asc"
    DescendingSort -> "desc"
  }
}

pub fn get_market_query(
  sort_by: MarketSortBy,
  sort_direction: SortDirection,
  search: Result(String, Nil),
) -> String {
  let query = [
    #("sort_by", sort_by_to_string(sort_by)),
    #("sort_direction", sort_direction_to_string(sort_direction)),
  ]

  let search_addition =
    handle_search(search, fn(search) { [#("search", search)] }, list.new)

  "?"
  <> list.flatten([query, search_addition])
  |> uri.query_to_string
}

pub fn get_market_items(
  filter: MarketItemsFilter,
  ctx: RequestContext,
) -> Result(List(SelectMarketItemsRow), InternalError(Nil)) {
  let search = handle_search(filter.search, name_query, fn() { "" })

  use _, rows <- errors.try_query(sql.select_market_items(
    ctx.db,
    filter.market_id,
    search,
    filter.sort_by |> sort_by_to_string,
    filter.sort_direction |> sort_direction_to_string |> string.uppercase,
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

pub fn search_market_item_names(
  market_id: Int,
  search: String,
  ctx: RequestContext,
) -> Result(List(String), InternalError(Nil)) {
  use _, rows <- errors.try_query(sql.select_market_item_names(
    ctx.db,
    market_id,
    name_query(search),
  ))

  rows
  |> list.map(fn(row) { row.name })
  |> Ok
}

fn name_query(search: String) {
  // todo: check if we need to replace " " with <-> instead
  string.replace(search, each: " ", with: "+") <> ":*"
}
