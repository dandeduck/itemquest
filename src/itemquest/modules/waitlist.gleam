import gleam/http
import itemquest/modules/waitlist/controller
import itemquest/web/contexts.{type RequestContext}
import wisp.{type Request, type Response}

pub fn handle_request(req: Request, ctx: RequestContext) -> Response {
  case req.method {
    http.Get -> controller.get_waitlist(req)
    http.Post -> controller.post_waitlist(req, ctx)
    _ -> wisp.method_not_allowed(allowed: [http.Get, http.Post])
  }
}
