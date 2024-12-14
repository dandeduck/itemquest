import gleam/http
import gleam/string_tree
import itemquest/pages/home
import itemquest/pages/layout
import itemquest/web
import itemquest/web/contexts.{
  type RequestContext, type ServerContext,
}
import lustre/element
import wisp.{type Request, type Response}

pub fn handle_request(req: Request, ctx: ServerContext) -> Response {
  use req, ctx <- web.middleware(req, ctx)

  case wisp.path_segments(req) {
    [] -> home_page(req)
    ["users"] -> get_items(req, ctx)
    _ -> wisp.not_found()
  }
}

pub fn home_page(req: Request) -> Response {
  use <- wisp.require_method(req, http.Get)

  home.page()
  |> layout.layout
  |> element.to_document_string_builder
  |> wisp.html_response(200)
}

pub fn get_items(req: Request, ctx: RequestContext) -> Response {
  use <- wisp.require_method(req, http.Get)
  use user <- get_user(ctx)

  let html =
    string_tree.from_string(
      "<h2> Items for user" <> user.id <> " " <> user.name <> "</h2>",
    )

  wisp.ok()
  |> wisp.html_body(html)
}

type User {
  User(id: String, name: String)
}

fn get_user(ctx: RequestContext, handle_user: fn(User) -> Response) -> Response {
  case ctx {
    contexts.Authorized(_, _, id) -> handle_user(User(id, "dude"))
    _ -> wisp.response(401)
  }
}
