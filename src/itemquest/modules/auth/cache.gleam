import gleam/result
import itemquest/utils/cache
import itemquest/web/contexts.{type RequestContext}
import itemquest/web/errors.{type InternalError}
import radish/command

pub fn token_exists(
  token_id: String,
  ctx: RequestContext,
) -> Result(Bool, InternalError(Nil)) {
  use exists <- result.try(cache.key_exists(token_id, ctx))

  Ok(exists)
}

pub fn save_token(
  id token_id: String,
  token token: String,
  ttl time_to_live: Int,
  ctx ctx: RequestContext,
) -> Result(Nil, InternalError(Nil)) {
  use _ <- result.try(cache.set(
    token_id,
    token,
    [command.EX(time_to_live)],
    ctx,
  ))

  Ok(Nil)
}
