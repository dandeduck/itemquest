import itemquest/modules/market/controller
import itemquest/modules/market/submodules/item
import itemquest/utils/handling
import itemquest/web/contexts.{type RequestContext}
import wisp.{type Request, type Response}

pub fn handle_request(
  market_id: Int,
  relative_segments: List(String),
  req: Request,
  ctx: RequestContext,
) -> Response {
  case relative_segments {
    [] -> controller.get_market(market_id, req, ctx)
    ["items-table"] -> controller.get_market_items_table(market_id, req, ctx)
    ["items"] -> controller.get_market_items(market_id, req, ctx)
    ["items", "search"] ->
      controller.get_market_items_search(market_id, req, ctx)
    ["items", item_id, ..segments] -> {
      use item_id <- handling.require_int_string(item_id)
      item.handle_request(market_id:, item_id:, req:, ctx:, segments:)
    }
    _ -> wisp.not_found()
  }
}
