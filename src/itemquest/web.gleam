import gleam/string
import wisp.{type Request, type Response}

pub type Context {
  Unauthorized(request_id: String)
  Authorized(request_id: String, user_id: String)
}

pub fn middleware(
  req: Request,
  handle_request: fn(Request, Context) -> Response,
) -> Response {
  let req = wisp.method_override(req)

  use ctx <- create_context(req)

  use <- wisp.log_request(req)
  use <- wisp.rescue_crashes
  use <- wisp.serve_static(req, under: "/static", from: "/public")

  use req <- wisp.handle_head(req)

  handle_request(req, ctx)
}

const test_user_id = "kjsdnfukyh2873h2uifhusgefhisdf"

fn create_context(
  _req: Request,
  handle_request: fn(Context) -> Response,
) -> Response {
  let context = Authorized(random_string(64), test_user_id)

  handle_request(context)
}

pub fn random_string(length: Int) -> String {
    length
    |> wisp.random_string
    |> string.replace(each: "-", with: "_")
}
