import itemquest/modules/waitlist
import itemquest/web
import itemquest/web/contexts.{type RequestContext, type ServerContext}
import wisp.{type Request, type Response}

pub fn handle_request(req: Request, ctx: ServerContext) -> Response {
  use req, ctx <- web.middleware(req, ctx)

  case wisp.path_segments(req) {
    [] -> waitlist.handle_get_waitlist(req)
    ["waitlist"] -> waitlist.handle_post_waitlist(req, ctx)
    //   ["markets", id] -> market_page(id, req, ctx)
    _ -> wisp.redirect("/")
  }
}

