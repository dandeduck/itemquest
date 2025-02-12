import gleam/http
import gleam/json
import gleam/list
import gleam/string
import itemquest/modules/auth/internal
import itemquest/utils/handling
import itemquest/utils/logging
import itemquest/web/contexts.{type RequestContext}
import wisp.{type Request, type Response}

pub fn post_refresh_tokens(req: Request, ctx: RequestContext) -> Response {
  use <- wisp.require_method(req, http.Post)

  case extract_token(req, ctx) {
    Ok(token) ->
      case internal.refresh_tokens(token, ctx) {
        Ok(new_tokens) ->
          json.object([
            #("access_token", json.string(new_tokens.access)),
            #("refresh_token", json.string(new_tokens.refresh)),
          ])
          |> json.to_string_tree
          |> wisp.json_response(201)
        Error(_) -> wisp.internal_server_error()
      }
    Error(_) -> handling.unauthorized()
  }
}

pub fn extract_token(req: Request, ctx: RequestContext) -> Result(String, Nil) {
  let header = list.key_find(req.headers, "Authorization")

  case header {
    Ok(header) -> {
      let parts = string.split(header, " ")

      case parts {
        [token_type, token] if token_type == "Bearer" -> Ok(token)
        _ -> {
          logging.log_error(
            "Authorization header is malformed: '" <> header <> "'",
            ctx,
          )
          Error(Nil)
        }
      }
    }
    Error(_) -> Error(Nil)
  }
}
