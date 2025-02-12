import gleam/result
import gleam/string
import ids/uuid
import itemquest/web/errors.{type InternalError}

pub fn generate_id() -> Result(String, InternalError(t)) {
  use id <- result.try(
    uuid.generate_v4()
    |> result.map_error(fn(error) { errors.Operational(error) }),
  )

  id
  |> string.replace("-", "")
  |> Ok
}
