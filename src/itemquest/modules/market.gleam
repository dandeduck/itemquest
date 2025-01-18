import gleam/http
import gleam/list
import gleam/option
import gleam/uri
import itemquest/modules/market/internal
import itemquest/modules/market/sql.{type SelectMarketRow}
import itemquest/modules/market/ui/item_page
import itemquest/modules/market/ui/market_page
import itemquest/utils/handling
import itemquest/utils/ui/layout
import itemquest/web/contexts.{type RequestContext}
import itemquest/web/errors
import lustre/element
import wisp.{type Request, type Response}

pub fn handle_get_market(
  market_id: String,
  req: Request,
  ctx: RequestContext,
) -> Response {
  use <- wisp.require_method(req, http.Get)

  let query = wisp.get_query(req)
  let search = list.key_find(query, "search")
  let sort_by = handling.optional_list_key(query, "sort_by", "quantity")
  let sort_direction =
    handling.optional_list_key(query, "sort_direction", "desc")

  let market_items_uri =
    uri.Uri(
      option.None,
      option.None,
      option.None,
      option.None,
      "/markets/" <> market_id <> "/items",
      req.query,
      option.None,
    )

  use market_id <- handling.require_int_string(market_id)
  use sort_by <- handling.require_ok_result(internal.sort_by_from_string(
    sort_by,
  ))
  use sort_direction <- handling.require_ok_result(
    internal.sort_direction_from_string(sort_direction),
  )

  use market <- require_market(market_id, ctx)

  market_page.page(market, market_items_uri, sort_by, sort_direction, search)
  |> layout.layout
  |> element.to_document_string_builder
  |> wisp.html_response(200)
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

pub fn handle_get_market_items(
  market_id: String,
  req: Request,
  ctx: RequestContext,
) -> Response {
  use <- wisp.require_method(req, http.Get)
  let query = wisp.get_query(req)
  let search = list.key_find(query, "search")
  let sort_by = handling.optional_list_key(query, "sort_by", "quantity")
  let sort_direction =
    handling.optional_list_key(query, "sort_direction", "desc")
  let limit = handling.optional_list_key(query, "limit", "25")
  let offset = handling.optional_list_key(query, "offset", "0")

  use market_id <- handling.require_int_string(market_id)
  use sort_by <- handling.require_ok_result(internal.sort_by_from_string(
    sort_by,
  ))
  use sort_direction <- handling.require_ok_result(
    internal.sort_direction_from_string(sort_direction),
  )
  use limit <- handling.require_int_string(limit)
  use offset <- handling.require_int_string(offset)

  case
    internal.get_market_items(
      internal.MarketItemsFilter(
        market_id:,
        search:,
        sort_by:,
        sort_direction:,
        limit:,
        offset:,
      ),
      ctx,
    )
  {
    Ok(items) ->
      case items {
        [] -> wisp.no_content()
        _ ->
          market_page.market_rows_stream(market_id, items)
          |> element.to_document_string_builder
          |> handling.turbo_stream_html_response(200)
      }
    // todo: show error instead
    Error(_) -> wisp.internal_server_error()
  }
}

pub fn handle_get_market_items_search(
  market_id: String,
  req: Request,
  ctx: RequestContext,
) -> Response {
  use <- wisp.require_method(req, http.Get)
  let query = wisp.get_query(req)
  let search = list.key_find(query, "search")

  use market_id <- handling.require_int_string(market_id)
  use search <- handling.require_ok_result(search)

  let names = case search {
    "" -> Ok([])
    _ -> internal.search_market_item_names(market_id, search, ctx)
  }

  case names {
    Ok(names) -> {
      names
      |> market_page.search_results_stream
      |> element.to_document_string_builder
      |> handling.turbo_stream_html_response(200)
    }
    // todo: show somethin' bro
    Error(_) -> wisp.internal_server_error()
  }
}

pub fn handle_get_market_item(
  market_id: String,
  item_id: String,
  req: Request,
  ctx: RequestContext,
) -> Response {
  use <- wisp.require_method(req, http.Get)

  use market_id <- handling.require_int_string(market_id)
  use item_id <- handling.require_int_string(item_id)

  case internal.get_market_item(item_id, market_id, ctx) {
    Ok(item) ->
      item
      |> item_page.page
      |> layout.layout
      |> element.to_document_string_builder
      |> wisp.html_response(200)
    Error(error) ->
      case error {
        // todo - display not found content or handle this at a higher level
        errors.Business(_, internal.ItemNotFoundError) -> wisp.not_found()
        _ -> wisp.internal_server_error()
      }
  }
}

pub fn handle_get_market_item_prices(
  item_id: String,
  req: Request,
  ctx: RequestContext,
) -> Response {
  use <- wisp.require_method(req, http.Get)
  let query = wisp.get_query(req)

  use period <- handling.require_list_key(query, "period")
  use period <- handling.require_ok_result(internal.price_period_from_string(
    period,
  ))

  use item_id <- handling.require_int_string(item_id)

  case internal.get_item_prices(item_id, period, ctx) {
    Ok(prices) -> wisp.ok()
    Error(error) ->
      case error {
        _ -> wisp.internal_server_error()
      }
  }
}
