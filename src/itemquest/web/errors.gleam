import itemquest/utils/logging
import itemquest/web/contexts.{type RequestContext}
import pog.{type QueryError}

pub type InternalError(t) {
  Business(message: String, data: t)
  Operational(message: String)
}

pub fn try_query(
  result: Result(pog.Returned(t), QueryError),
  ctx: RequestContext,
  handle_returned: fn(Int, List(t)) -> Result(r, InternalError(e)),
) -> Result(r, InternalError(e)) {
  case result {
    Ok(pog.Returned(length, rows)) -> handle_returned(length, rows)
    Error(error) ->
      error |> from_query_error |> log_internal_error(ctx) |> Error
  }
}

pub fn log_internal_error(
  error: InternalError(t),
  ctx: RequestContext,
) -> InternalError(t) {
  case error {
    Business(message, _) -> logging.log_warning("Business: " <> message, ctx)
    Operational(message) -> logging.log_error("Operational: " <> message, ctx)
  }

  error
}

pub fn from_query_error(error: QueryError) -> InternalError(t) {
  error
  |> query_error_message
  |> Operational
}

fn query_error_message(error: QueryError) -> String {
  case error {
    pog.ConstraintViolated(message, constraint, detail) ->
      "DB constraint violated: '"
      <> constraint
      <> "' "
      <> message
      <> " detail: "
      <> detail
    pog.PostgresqlError(code, name, message) ->
      "Query failed within the DB " <> code <> " " <> name <> " " <> message
    pog.UnexpectedArgumentCount(..) ->
      "Query called with incorrect amount of arguments"
    pog.UnexpectedArgumentType(expected, got) ->
      "Query called with incrrect argument type, expected: "
      <> expected
      <> " got "
      <> got
    pog.UnexpectedResultType(_) -> "Returned rows could not be decoded"
    pog.QueryTimeout -> "Query timeout"
    pog.ConnectionUnavailable -> "Connection unavailable"
  }
}
