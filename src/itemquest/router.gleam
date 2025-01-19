import itemquest/modules/market
import itemquest/modules/waitlist
import itemquest/web
import itemquest/web/contexts.{type ServerContext}
import wisp.{type Request, type Response}

pub fn handle_request(req: Request, ctx: ServerContext) -> Response {
  use req, ctx <- web.middleware(req, ctx)

  case wisp.path_segments(req) {
    [] -> waitlist.handle_get_waitlist(req)
    ["waitlist"] -> waitlist.handle_post_waitlist(req, ctx)
    ["markets", id] -> market.handle_get_market(id, req, ctx)
    ["markets", id, "items"] -> market.handle_get_market_items(id, req, ctx)
    ["markets", id, "items", "search"] ->
      market.handle_get_market_items_search(id, req, ctx)
    ["markets", market_id, "items", item_id] ->
      market.handle_get_market_item(market_id, item_id, req, ctx)
    ["markets", market_id, "items", item_id, "prices"] ->
      market.handle_get_market_item_prices(market_id, item_id, req, ctx)
    _ -> wisp.redirect("/")
    // todo: return 404 page
  }
}
