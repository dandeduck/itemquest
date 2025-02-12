import itemquest/modules/auth/controller
import itemquest/modules/auth/internal
import itemquest/web/contexts.{type Authentication, type RequestContext}
import wisp.{type Request, type Response}

pub fn authenticate_request(req: Request, ctx: RequestContext) -> Authentication {
  case controller.extract_token(req, ctx) {
    Ok(token) -> internal.authenticate_access_token(token, ctx)
    Error(_) -> contexts.Unauthenticated
  }
}

pub fn handle_request(
  relative_segments: List(String),
  req: Request,
  ctx: RequestContext,
) -> Response {
  case relative_segments {
    ["refresh"] -> controller.post_refresh_tokens(req, ctx)
    _ -> wisp.not_found()
  }
}
