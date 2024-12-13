import gleam/http.{Get}
import gleam/io
import gleam/string_tree
import itemquest/contexts.{type RequestContext, type ServerContext, Authorized}
import itemquest/pages/home
import itemquest/pages/layout
import itemquest/sql
import itemquest/web
import lustre/element
import pog
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
  use <- wisp.require_method(req, Get)

  home.page()
  |> layout.layout
  |> element.to_document_string_builder
  |> wisp.html_response(200)
}

pub fn get_items(req: Request, ctx: RequestContext) -> Response {
  use <- wisp.require_method(req, Get)
  use user <- get_user(ctx)

  let html =
    string_tree.from_string(
      "<h2> Items for user" <> user.id <> " " <> user.name <> "</h2>",
    )
  let assert Ok(pog.Returned(_rows_count, rows)) =
    sql.find_template_market_entry(ctx.db, 123)
  // let assert [row] = rows

  io.debug(rows)

  wisp.ok()
  |> wisp.html_body(html)
}

type User {
  User(id: String, name: String)
}

fn get_user(ctx: RequestContext, handle_user: fn(User) -> Response) -> Response {
  case ctx {
    Authorized(_, _, id) -> handle_user(User(id, "dude"))
    _ -> wisp.response(401)
  }
}
