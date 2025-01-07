import gleam/http/response
import gleam/int
import gleam/list
import gleam/string_tree.{type StringTree}
import wisp.{type FormData, type Response}

pub fn require_form_key(
  form: FormData,
  name: String,
  handle_request: fn(String) -> Response,
) -> Response {
  require_list_key(form.values, name, handle_request)
}

pub fn optional_list_key(
  values: List(#(String, String)),
  name: String,
  default: String,
) -> String {
  case list.key_find(values, name) {
    Ok(value) -> value
    Error(_) -> default
  }
}

pub fn require_list_key(
  values: List(#(String, t)),
  name: String,
  handle_request: fn(t) -> Response,
) -> Response {
  case list.key_find(values, name) {
    Ok(value) -> handle_request(value)
    Error(_) -> wisp.bad_request()
  }
}

pub fn require_int_string(
  value: String,
  handle_request: fn(Int) -> Response,
) -> Response {
  case int.parse(value) {
    Ok(value) -> handle_request(value)
    Error(_) -> wisp.bad_request()
  }
}

pub fn turbo_stream_html_response(body: StringTree, status: Int) -> Response {
  body
  |> wisp.Text
  |> response.Response(
    status,
    [#("content-type", "text/vnd.turbo-stream.html")],
    _,
  )
}
