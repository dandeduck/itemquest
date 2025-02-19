import gleam/result
import itemquest/web/errors.{type InternalError}
import youid/uuid

pub type Uuid =
  uuid.Uuid

pub fn generate_id() -> String {
  uuid.v4() |> format
}

pub fn format(id: Uuid) -> String {
  id |> uuid.format(uuid.Hex)
}

pub type ParseIdError {
  InvalidIdString
}

pub fn parse_id(id: String) -> Result(Uuid, InternalError(ParseIdError)) {
  uuid.from_string(id)
  |> result.map_error(fn(_) {
    errors.Business("Passed ID's format is incorrect", InvalidIdString)
  })
}
