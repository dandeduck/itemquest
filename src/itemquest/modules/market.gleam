import gleam/http
import gleam/http/response
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
  use market <- require_market(market_id, ctx)

  ui.page(market, uri.to_string(market_entries_uri))
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
  let sort_by = handling.optional_list_key(query, "sort_by", "quantity")
  let limit = handling.optional_list_key(query, "limit", "25")
  let offset = handling.optional_list_key(query, "offset", "0")

  use market_id <- handling.require_int_string(market_id)
  use sort_by <- handling.require_list_key(internal.sort_by_touples, sort_by)
  use limit <- handling.require_int_string(limit)
  use offset <- handling.require_int_string(offset)

  case
    internal.get_market_entries(
      internal.MarketEntriesSearch(market_id:, sort_by:, limit:, offset:),
      ctx,
    )
  {
    Ok(entries) ->
      ui.market_rows(entries)
      |> element.to_document_string_builder
      |> handling.turbo_stream_html_response(200)
    // todo: show error instead
    Error(_) -> wisp.internal_server_error()
  }
}
