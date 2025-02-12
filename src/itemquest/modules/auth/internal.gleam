import gleam/erlang
import gleam/result
import gleam/string
import gwt
import itemquest/modules/auth/cache
import itemquest/utils/ids
import itemquest/utils/logging
import itemquest/web/contexts.{type Authentication, type RequestContext}
import itemquest/web/errors.{type InternalError}

pub type Audience {
  Api
  Platform
}

pub type Tokens {
  Tokens(access: String, refresh: String)
}

pub type RefreshTokenError {
  InvalidToken
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

pub fn refresh_tokens(
  refresh_token: String,
  ctx: RequestContext,
) -> Result(Tokens, InternalError(RefreshTokenError)) {
  use old_token <- result.try(authenticate_refresh_token(refresh_token, ctx))
  use tokens <- result.try(generate_tokens(
    old_token.subject,
    old_token.audience,
    ctx,
  ))
  use _ <- result.try(cache.delete_token(old_token.id, ctx))

  Ok(tokens)
}

fn authenticate_refresh_token(
  token: String,
  ctx: RequestContext,
) -> Result(Token, InternalError(RefreshTokenError)) {
  use token <- result.try(verify_token(token, ctx))
  use exists <- result.try(cache.token_exists(token.id, ctx))

  case exists {
    True -> Ok(token)
    False ->
      InvalidToken
      |> errors.Business("Refresh token does not exist", _)
      |> Error
  }
}

const platform_access_token_ttl = 900

const api_access_token_ttl = 1800

const refresh_token_ttl = 259_200

fn generate_tokens(
  subject: String,
  audience: Audience,
  ctx: RequestContext,
) -> Result(Tokens, InternalError(t)) {
  let now = erlang.system_time(erlang.Second)

  let access_token_ttl = case audience {
    Platform -> platform_access_token_ttl
    Api -> api_access_token_ttl
  }

  use #(_, access_token) <- result.try(generate_token(
    now,
    subject,
    audience,
    access_token_ttl,
    ctx,
  ))
  use #(refresh_token_id, refresh_token) <- result.try(generate_token(
    now,
    subject,
    audience,
    refresh_token_ttl,
    ctx,
  ))

  use _ <- result.try(cache.save_token(
    refresh_token_id,
    refresh_token,
    refresh_token_ttl,
    ctx,
  ))

  Ok(Tokens(access: access_token, refresh: refresh_token))
}

fn generate_token(
  time_seconds: Int,
  subject: String,
  audience: Audience,
  ttl_seconds: Int,
  ctx: RequestContext,
) -> Result(#(String, String), InternalError(a)) {
  let saved_audience = case audience {
    Platform -> "platform"
    Api -> "api"
  }

  use token_id <- result.try(ids.generate_id())
  let expiration = { time_seconds + ttl_seconds } * 1000

  let token =
    gwt.new()
    |> gwt.set_subject(subject)
    |> gwt.set_audience(saved_audience)
    |> gwt.set_expiration(expiration)
    |> gwt.set_jwt_id(token_id)
    |> gwt.to_signed_string(gwt.HS256, ctx.secrets.jwt)

  Ok(#(token_id, token))
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
) -> Result(Token, InternalError(t)) {
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
