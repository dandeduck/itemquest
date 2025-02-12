import gleam/result
import itemquest/utils/cache
import itemquest/web/contexts.{type RequestContext}
import itemquest/web/errors.{type InternalError}
import radish/command

pub fn token_exists(
  token_id: String,
  ctx: RequestContext,
) -> Result(Bool, InternalError(t)) {
  cache.key_exists(token_id, ctx)
}

pub fn delete_token(
  token_id: String,
  ctx: RequestContext,
) -> Result(Nil, InternalError(t)) {
  use _ <- result.try(cache.del(token_id, ctx))

  Ok(Nil)
}

pub fn save_token(
  id token_id: String,
  token token: String,
  ttl time_to_live: Int,
  ctx ctx: RequestContext,
) -> Result(Nil, InternalError(t)) {
  use _ <- result.try(cache.set(
    token_id,
    token,
    [command.EX(time_to_live)],
    ctx,
  ))

  Ok(Nil)
}
