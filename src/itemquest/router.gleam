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
    ["markets", id] -> market.handle_get_market_by_id(id, req, ctx)
    ["markets", id, "entries"] -> market.handle_get_market_entries(id, req, ctx)
    _ -> wisp.redirect("/")
    // todo: return 404 page
  }
}
