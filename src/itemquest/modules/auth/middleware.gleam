import itemquest/utils/handling
import itemquest/web/contexts.{type RequestContext}
import wisp.{type Response}

pub fn require_platform_authorized(
  ctx: RequestContext,
  handle_request: fn(String) -> Response,
) -> Response {
  case ctx.auth {
    contexts.PlatformUser(user_id) -> handle_request(user_id)
    contexts.ApiClient(_) -> handling.forbidden()
    _ -> handling.unauthorized()
  }
}

pub fn require_api_authorized(
  ctx: RequestContext,
  handle_request: fn(String) -> Response,
) -> Response {
  case ctx.auth {
    contexts.ApiClient(client_id) -> handle_request(client_id)
    contexts.PlatformUser(_) -> handling.forbidden()
    _ -> handling.unauthorized()
  }
}
