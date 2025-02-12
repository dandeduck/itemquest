import itemquest/modules/market/submodules/item/controller
import itemquest/modules/market/submodules/item/internal
import itemquest/web/contexts.{type RequestContext}
import wisp.{type Request, type Response}

pub fn handle_request(
  market_id market_id: Int,
  item_id item_id: Int,
  segments relative_segments: List(String),
  req req: Request,
  ctx ctx: RequestContext,
) -> Response {
  case relative_segments {
    [] -> controller.handle_get_market_item(market_id, item_id, req, ctx)
    ["prices"] -> controller.handle_get_market_item_prices(item_id, req, ctx)
    ["listings"] ->
      controller.handle_get_market_item_listings(item_id, req, ctx)
    _ -> wisp.not_found()
    // todo: 404
  }
}

pub const create_market_item = internal.create_market_item
