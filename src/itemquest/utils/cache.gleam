import gleam/result
import itemquest/web/contexts.{type RequestContext}
import itemquest/web/errors.{type InternalError}
import radish
import radish/command.{type SetOption}
import radish/error as cache_error
import radish/resp
import radish/utils

const default_timeout = 5

pub fn set(
  key: String,
  value: String,
  options: List(SetOption),
  ctx: RequestContext,
) {
  command.set(key, value, options)
  |> utils.execute(ctx.cache, _, default_timeout)
  |> result.map(fn(value) {
    case value {
      [resp.SimpleString(str)] | [resp.BulkString(str)] -> Ok(str)
      _ ->
        cache_error.RESPError
        |> errors.from_cache_error
        |> Error
    }
  })
  |> result.map_error(errors.from_cache_error)
  |> result.flatten
  |> result.map_error(errors.log_internal_error(_, ctx))
}

pub fn key_exists(
  key: String,
  ctx: RequestContext,
) -> Result(Bool, InternalError(a)) {
  case radish.exists(ctx.cache, [key], default_timeout) {
    Ok(num) -> Ok(num == 1)
    Error(error) ->
      error
      |> errors.from_cache_error
      |> errors.log_internal_error(ctx)
      |> Error
  }
}
