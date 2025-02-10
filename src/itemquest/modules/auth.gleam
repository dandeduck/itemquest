import gleam/list
import gleam/string
import itemquest/modules/auth/internal
import itemquest/utils/logging
import itemquest/web/contexts.{type Authentication, type RequestContext}
import wisp.{type Request}

pub fn authenticate_request(req: Request, ctx: RequestContext) -> Authentication {
  use token <- retrieve_token(req, ctx)

  internal.authenticate_access_token(token, ctx)
}

fn retrieve_token(
  req: Request,
  ctx: RequestContext,
  handle_token: fn(String) -> Authentication,
) -> Authentication {
  let header = list.key_find(req.headers, "Authorization")

  case header {
    Ok(header) -> {
      let parts = string.split(header, " ")

      case parts {
        [token_type, token] if token_type == "Bearer" -> handle_token(token)
        _ -> {
          logging.log_error(
            "Authorization header is malformed: '" <> header <> "'",
            ctx,
          )
          contexts.Unauthenticated
        }
      }
    }
    Error(_) -> contexts.Unauthenticated
  }
}
