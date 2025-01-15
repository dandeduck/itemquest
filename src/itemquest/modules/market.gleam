import gleam/http
import gleam/io
import gleam/list
import gleam/option
import gleam/uri
import itemquest/modules/market/internal
import itemquest/modules/market/sql.{type SelectMarketRow}
import itemquest/modules/market/ui
import itemquest/utils/handling
import itemquest/utils/ui/layout
import itemquest/web/contexts.{type RequestContext}
import lustre/element
import wisp.{type Request, type Response}

pub fn handle_get_market_by_id(
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

  let market_entries_uri =
    uri.Uri(
      option.None,
      option.None,
      option.None,
      option.None,
      "/markets/" <> market_id <> "/entries",
      req.query,
      option.None,
    )

  use market_id <- handling.require_int_string(market_id)
  use sort_by <- handling.require_list_key(internal.sort_by_touples, sort_by)
  use sort_direction <- handling.require_list_key(
    internal.sort_direction_touples,
    sort_direction,
  )

  use market <- require_market(market_id, ctx)

  ui.page(market, market_entries_uri, sort_by, sort_direction, search)
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

pub fn handle_get_market_entries(
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
  use sort_by <- handling.require_list_key(internal.sort_by_touples, sort_by)
  use sort_direction <- handling.require_list_key(
    internal.sort_direction_touples,
    sort_direction,
  )
  use limit <- handling.require_int_string(limit)
  use offset <- handling.require_int_string(offset)

  case
    internal.get_market_entries(
      internal.MarketEntriesFilter(
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
    Ok(entries) ->
      case entries {
        [] -> wisp.no_content()
        _ ->
          ui.market_rows(entries)
          |> element.to_document_string_builder
          |> handling.turbo_stream_html_response(200)
      }
    // todo: show error instead
    Error(_) -> wisp.internal_server_error()
  }
}

pub fn handle_get_market_entries_search(
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
    _ -> internal.search_market_entry_names(market_id, search, ctx)
  }

  case names {
    Ok(names) -> {
      io.debug(names)
      ui.search_results(names)
      |> element.to_document_string_builder
      |> handling.turbo_stream_html_response(200)
    }
    // todo: show somethin' bro
    Error(_) -> wisp.internal_server_error()
  }
}
