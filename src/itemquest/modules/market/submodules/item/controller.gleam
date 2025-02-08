import gleam/http
import itemquest/modules/market/submodules/item/internal
import itemquest/modules/market/submodules/item/ui
import itemquest/utils/handling
import itemquest/utils/ui/layout
import itemquest/web/contexts.{type RequestContext}
import itemquest/web/errors
import lustre/element
import wisp.{type Request, type Response}

pub fn handle_get_market_item(
  market_id: Int,
  item_id: Int,
  req: Request,
  ctx: RequestContext,
) -> Response {
  use <- wisp.require_method(req, http.Get)

  case internal.get_item(item_id, market_id, ctx) {
    Ok(item) ->
      item
      |> ui.page
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
  item_id: Int,
  req: Request,
  ctx: RequestContext,
) -> Response {
  use <- wisp.require_method(req, http.Get)
  let query = wisp.get_query(req)

  let period = handling.optional_list_key(query, "period", "day")
  use period <- handling.require_ok_result(internal.price_period_from_string(
    period,
  ))

  case internal.get_item_prices(item_id, period, ctx) {
    Ok(rows) ->
      rows
      |> ui.prices()
      |> element.to_document_string_builder
      |> wisp.html_response(200)
    Error(_) -> wisp.internal_server_error()
  }
}

pub fn handle_get_market_item_listings(
  item_id: Int,
  req: Request,
  ctx: RequestContext,
) -> Response {
  use <- wisp.require_method(req, http.Get)
  let query = wisp.get_query(req)

  let offset = handling.optional_list_key(query, "offset", "0")
  let limit = handling.optional_list_key(query, "limit", "25")

  use limit <- handling.require_int_string(limit)
  use offset <- handling.require_int_string(offset)

  case internal.get_item_listings(item_id, limit, offset, ctx) {
    Ok(listings) ->
      listings
      |> ui.listings()
      |> element.to_document_string_builder
      |> wisp.html_response(200)
    Error(_) -> wisp.internal_server_error()
  }
}
