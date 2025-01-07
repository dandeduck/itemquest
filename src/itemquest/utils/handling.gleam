import gleam/list
import wisp.{type FormData, type Response}

pub fn require_form_key(
  form: FormData,
  name: String,
  handle_request: fn(String) -> Response,
) -> Response {
  require_list_key(form.values, name, handle_request)
}

pub fn require_query_key(query: List(#(String, String)), name: String, handle_request: fn(String) -> Response) -> Response {
  require_list_key(query, name, handle_request)
}

fn require_list_key(
  values: List(#(String, String)),
  name: String,
  handle_request: fn(String) -> Response,
) -> Response {
  case list.key_find(values, name) {
    Ok(value) -> handle_request(value)
    Error(_) -> wisp.bad_request()
  }
}
