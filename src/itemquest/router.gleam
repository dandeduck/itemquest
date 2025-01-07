import itemquest/modules/waitlist
import gleam/http
import itemquest/pages/layout
import itemquest/pages/market
import itemquest/web
import itemquest/web/contexts.{type RequestContext, type ServerContext}
import lustre/element
import wisp.{type Request, type Response}

pub fn handle_request(req: Request, ctx: ServerContext) -> Response {
  use req, ctx <- web.middleware(req, ctx)

  case wisp.path_segments(req) {
    [] -> waitlist.get_waitlist(req)
    ["waitlist"] -> waitlist.post_waitlist(req, ctx)
    //   ["markets", id] -> market_page(id, req, ctx)
    _ -> wisp.redirect("/")
  }
}

pub fn market_page(
  market_id: String,
  req: Request,
  _ctx: RequestContext,
) -> Response {
  use <- wisp.require_method(req, http.Get)

  // let query = wisp.get_query(req)
  // let sort_by = list.find(query, fn(param) { param.0 == "sort_by" })
  // let limit = list.find(query, fn(param) { param.0 == "limit" })
  // let offset = list.find(query, fn(param) { param.0 == "offset" })

  market.page("Market " <> market_id)
  |> layout.layout
  |> element.to_document_string_builder
  |> wisp.html_response(200)
}
