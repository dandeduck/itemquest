import gleam/http.{Get}
import gleam/string_tree
import itemquest/web.{type Context, Authorized}
import wisp.{type Request, type Response}

pub fn handle_request(req: Request) -> Response {
  use req, ctx <- web.middleware(req)

  case wisp.path_segments(req) {
    [] -> home_page(req, ctx)
    ["users"] -> get_items(req, ctx)
    _ -> wisp.not_found()
  }
}

pub fn home_page(req: Request, ctx: Context) -> Response {
  use <- wisp.require_method(req, Get)
  let html =
    string_tree.from_string(
      "<h1>Hello request_id " <> ctx.request_id <> "</h1>",
    )

  wisp.ok()
  |> wisp.html_body(html)
}

pub fn get_items(req: Request, ctx: Context) -> Response {
  use <- wisp.require_method(req, Get)
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

fn get_user(ctx: Context, handle_user: fn(User) -> Response) -> Response {
  case ctx {
    Authorized(_, id) -> handle_user(User(id, "dude"))
    _ -> wisp.response(401)
  }
}
