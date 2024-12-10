import gleam/result
import gleam/string
import ids/uuid

pub fn generate_id() -> Result(String, String) {
  use id <- result.try(uuid.generate_v4())

  id
  |> string.replace("-", "")
  |> Ok
}
