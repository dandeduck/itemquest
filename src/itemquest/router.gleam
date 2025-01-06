import gleam/http
import gleam/io
import gleam/list
import itemquest/pages/home
import itemquest/pages/layout
import itemquest/pages/market
import itemquest/pages/waitlist
import itemquest/web
import itemquest/web/contexts.{type RequestContext, type ServerContext}
import lustre/element
import wisp.{type Request, type Response}

pub fn handle_request(req: Request, ctx: ServerContext) -> Response {
  use req, _ctx <- web.middleware(req, ctx)

  case wisp.path_segments(req) {
    [] -> waitlist_page(req)
    ["waitlist"] -> handle_waitlist(req)
    //   ["markets", id] -> market_page(id, req, ctx)
    _ -> wisp.redirect("/")
  }
}

pub fn handle_waitlist(req) {
  use <- wisp.require_method(req, http.Post)
  use data <- wisp.require_form(req)

  let email = list.key_find(data.values, "email")

  case email {
    Ok(email) -> io.debug(email)
    _ -> ""
  }

  // todo: return just the updated compent that replaces the form 
  waitlist.page()
  |> layout.layout
  |> element.to_document_string_builder
  |> wisp.html_response(200)
}

pub fn waitlist_page(req: Request) -> Response {
  use <- wisp.require_method(req, http.Get)

  waitlist.page()
  |> layout.layout
  |> element.to_document_string_builder
  |> wisp.html_response(200)
}

pub fn home_page(req: Request) -> Response {
  use <- wisp.require_method(req, http.Get)

  home.page()
  |> layout.layout
  |> element.to_document_string_builder
  |> wisp.html_response(200)
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
