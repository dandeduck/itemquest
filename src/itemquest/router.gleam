import itemquest/modules/market
import itemquest/modules/waitlist
import itemquest/utils/handling
import itemquest/web
import itemquest/web/contexts.{type ServerContext}
import wisp.{type Request, type Response}

pub fn handle_request(req: Request, ctx: ServerContext) -> Response {
  use req, ctx <- web.middleware(req, ctx)

  case wisp.path_segments(req) {
    [] -> waitlist.handle_get_waitlist(req)
    ["waitlist"] -> waitlist.handle_post_waitlist(req, ctx)
    ["markets", market_id, ..segments] -> {
      use market_id <- handling.require_int_string(market_id)
      market.handle_request(market_id, segments, req, ctx)
    }
    _ -> wisp.redirect("/")
    // todo: return 404 page
  }
}
