import pog.{type QueryError}

pub type InternalError(t) {
  Business(message: String, data: t)
  Operational(message: String)
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
