import gleam/http
import gleam/int
import gleam/string
import itemquest/utils/ids
import itemquest/utils/logging
import itemquest/web/contexts.{type RequestContext, type ServerContext}
import wisp.{type Request, type Response}

pub fn middleware(
  req: Request,
  server_ctx: ServerContext,
  handle_request: fn(Request, RequestContext) -> Response,
) -> Response {
  let req = wisp.method_override(req)

  use ctx <- create_context(req, server_ctx)

  use <- wisp.serve_static(
    req,
    under: "/generated",
    from: server_ctx.priv_directory <> "/generated",
  )
  use <- wisp.serve_static(
    req,
    under: "/public",
    from: server_ctx.priv_directory <> "/public",
  )
  use <- log_request(req, ctx)
  use <- wisp.rescue_crashes

  use req <- wisp.handle_head(req)

  handle_request(req, ctx)
}

fn log_request(
  req: Request,
  ctx: RequestContext,
  handler: fn() -> Response,
) -> Response {
  let response = handler()
  [
    ctx.request_id,
    " ",
    int.to_string(response.status),
    " ",
    string.uppercase(http.method_to_string(req.method)),
    " ",
    req.path,
  ]
  |> string.concat
  |> logging.log_info(ctx)
  response
}

const test_user_id = "kjsdnfukyh2873h2uifhusgefhisdf"

fn create_context(
  _req: Request,
  server_ctx: ServerContext,
  handle_request: fn(RequestContext) -> Response,
) -> Response {
  let context = contexts.Authorized(server_ctx.db, request_id(), test_user_id)

  handle_request(context)
}

const backup_request_id = "no_request_id"

fn request_id() -> String {
  let result = ids.generate_id()

  case result {
    Ok(id) -> id
    Error(error) -> {
      wisp.log_error(backup_request_id <> error)
      backup_request_id
    }
  }
}
