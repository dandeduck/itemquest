import gleam/result
import gleam/string
import gwt
import itemquest/utils/logging
import itemquest/web/contexts.{type Authentication, type RequestContext}
import itemquest/web/errors.{type InternalError}

pub fn authenticate_access_token(
  token: String,
  ctx: RequestContext,
) -> Authentication {
  case authenticate_token(token, ctx) {
    Ok(auth) -> auth
    Error(error) -> {
      logging.log_error("authenticate_access_token() - " <> error.message, ctx)
      contexts.Unauthenticated
    }
  }
}

pub fn authenticate_refresh_token(
  token: String,
  ctx: RequestContext,
) -> Authentication {
  // todo: go to redis or postgres and check if it's still valid
  case authenticate_token(token, ctx) {
    Ok(auth) -> auth
    Error(error) -> {
      logging.log_error("authenticate_access_token() - " <> error.message, ctx)
      contexts.Unauthenticated
    }
  }
}

fn authenticate_token(
  token: String,
  ctx: RequestContext,
) -> Result(Authentication, InternalError(Nil)) {
  case gwt.from_signed_string(token, ctx.secrets.jwt) {
    Ok(jwt) -> {
      let subject = gwt.get_subject(jwt)
      let audience = gwt.get_audience(jwt)

      case result.all([subject, audience]) {
        Ok(claims) -> {
          let assert [subject, audience] = claims

          case audience {
            "api" -> Ok(contexts.ApiClient(subject))
            "platform" -> Ok(contexts.PlatformUser(subject))
            value ->
              ["Received and unsupported audience value of", value]
              |> string.join(" ")
              |> errors.Operational
              |> Error
          }
        }
        Error(error) ->
          [
            "JWT wasn't created properly",
            string.inspect(error),
            "missing object or audience claims",
          ]
          |> string.join(" ")
          |> errors.Operational
          |> Error
      }
    }
    Error(error) ->
      ["Failed to decode JWT", string.inspect(error)]
      |> string.join(" ")
      |> errors.Operational
      |> Error
  }
}
