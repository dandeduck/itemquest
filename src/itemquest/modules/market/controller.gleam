import gleam/http
import gleam/list
import itemquest/modules/market/internal.{type MarketItemsFilter}
import itemquest/modules/market/sql.{type SelectMarketRow}
import itemquest/modules/market/ui
import itemquest/utils/handling
import itemquest/utils/ui/layout
import itemquest/web/contexts.{type RequestContext}
import lustre/element
import wisp.{type Request, type Response}

pub fn get_market(market_id: Int, req: Request, ctx: RequestContext) -> Response {
  use <- wisp.require_method(req, http.Get)

  let query = wisp.get_query(req)
  use filter <- parse_market_query(query, market_id)

  use market <- require_market(filter.market_id, ctx)

  ui.page(market, filter)
  |> layout.layout
  |> element.to_document_string_builder
  |> wisp.html_response(200)
}

pub fn get_market_items_table(
  market_id: Int,
  req: Request,
  ctx: RequestContext,
) -> Response {
  use <- wisp.require_method(req, http.Get)
  let query = wisp.get_query(req)
  use filter <- parse_market_query(query, market_id)

  case internal.get_market_items(filter, ctx) {
    Ok(#(count, items)) ->
      case items {
        [] -> wisp.no_content()
        _ ->
          ui.market_items_table(filter, items, count)
          |> element.to_document_string_builder
          |> wisp.html_response(200)
      }
    // todo: show error instead
    Error(_) -> wisp.internal_server_error()
  }
}

pub fn get_market_items(
  market_id: Int,
  req: Request,
  ctx: RequestContext,
) -> Response {
  use <- wisp.require_method(req, http.Get)
  let query = wisp.get_query(req)
  use filter <- parse_market_query(query, market_id)

  case internal.get_market_items(filter, ctx) {
    Ok(#(_, items)) ->
      case items {
        [] -> wisp.no_content()
        _ ->
          ui.market_rows_stream(filter, items)
          |> element.to_document_string_builder
          |> handling.turbo_stream_html_response(200)
      }
    // todo: show error instead
    Error(_) -> wisp.internal_server_error()
  }
}

pub fn get_market_items_search(
  market_id: Int,
  req: Request,
  ctx: RequestContext,
) -> Response {
  use <- wisp.require_method(req, http.Get)
  let query = wisp.get_query(req)
  let search = list.key_find(query, "search")

  use search <- handling.require_ok_result(search)

  let names = case search {
    "" -> Ok([])
    _ -> internal.search_market_item_names(market_id, search, ctx)
  }

  case names {
    Ok(names) -> {
      names
      |> ui.search_results_stream
      |> element.to_document_string_builder
      |> handling.turbo_stream_html_response(200)
    }
    // todo: show somethin' bro
    Error(_) -> wisp.internal_server_error()
  }
}

fn require_market(
  market_id: Int,
  ctx: RequestContext,
  handle_market: fn(SelectMarketRow) -> Response,
) -> Response {
  case internal.select_market(market_id, ctx) {
    Ok(market) -> handle_market(market)
    // todo: handle not found 404 vs 500 error and render different content than the page
    Error(_) -> wisp.bad_request()
  }
}

fn parse_market_query(
  query: List(#(String, String)),
  market_id: Int,
  handle_filter: fn(MarketItemsFilter) -> Response,
) -> Response {
  let search = list.key_find(query, "search")
  let sort_by = handling.optional_list_key(query, "sort_by", "quantity")
  let sort_direction =
    handling.optional_list_key(query, "sort_direction", "desc")
  let limit = handling.optional_list_key(query, "limit", "25")
  let offset = handling.optional_list_key(query, "offset", "0")

  use sort_by <- handling.require_ok_result(internal.sort_by_from_string(
    sort_by,
  ))
  use sort_direction <- handling.require_ok_result(
    internal.sort_direction_from_string(sort_direction),
  )
  use limit <- handling.require_int_string(limit)
  use offset <- handling.require_int_string(offset)

  handle_filter(internal.MarketItemsFilter(
    market_id:,
    sort_by:,
    sort_direction:,
    search:,
    limit:,
    offset:,
  ))
}
