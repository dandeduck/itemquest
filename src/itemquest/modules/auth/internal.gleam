import gleam/result
import gleam/string
import gwt
import itemquest/utils/logging
import itemquest/web/contexts.{type Authentication, type RequestContext}
import itemquest/web/errors.{type InternalError}

type Audience {
  Api
  Platform
}

type Token {
  Token(subject: String, audience: Audience, id: String)
}

pub fn authenticate_access_token(
  token: String,
  ctx: RequestContext,
) -> Authentication {
  case verify_token(token, ctx) {
    Ok(token) -> auth_from_token(token)
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
  case verify_token(token, ctx) {
    Ok(token) -> contexts.Unauthenticated
    //todo
    Error(error) -> {
      logging.log_error("authenticate_access_token() - " <> error.message, ctx)
      contexts.Unauthenticated
    }
  }
}

fn auth_from_token(token: Token) -> Authentication {
  case token.audience {
    Api -> contexts.ApiClient(client_id: token.subject)
    Platform -> contexts.PlatformUser(user_id: token.subject)
  }
}

fn verify_token(
  token: String,
  ctx: RequestContext,
) -> Result(Token, InternalError(Nil)) {
  case gwt.from_signed_string(token, ctx.secrets.jwt) {
    Ok(jwt) -> {
      let subject = gwt.get_subject(jwt)
      let audience = gwt.get_audience(jwt)
      let id = gwt.get_jwt_id(jwt)

      case result.all([subject, audience, id]) {
        Ok(claims) -> {
          let assert [subject, audience, id] = claims

          case audience {
            "api" -> Ok(Token(subject:, audience: Api, id:))
            "platform" -> Ok(Token(subject:, audience: Platform, id:))
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
