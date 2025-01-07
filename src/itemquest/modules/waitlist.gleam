import itemquest/utils/handling
import gleam/http
import itemquest/modules/waitlist/internal
import itemquest/modules/waitlist/ui
import itemquest/pages/layout
import itemquest/web/contexts.{type RequestContext}
import itemquest/web/errors
import lustre/element
import wisp.{type Request, type Response}

pub fn post_waitlist(req: Request, ctx: RequestContext) -> Response {
  use <- wisp.require_method(req, http.Post)
  use data <- wisp.require_form(req)
  use email <- handling.require_form_key(data, "email")

  // todo: return just the updated component that replaces the form, and add error/success messages
  case internal.add_waitlist_email(ctx, email) {
    Ok(_) ->
      ui.page()
      |> layout.layout
      |> element.to_document_string_builder
      |> wisp.html_response(200)
    Error(error) ->
      case error {
        errors.Business(_, _) ->
          ui.page()
          |> layout.layout
          |> element.to_document_string_builder
          |> wisp.html_response(200)
        errors.Operational(_message) ->
          ui.page()
          |> layout.layout
          |> element.to_document_string_builder
          |> wisp.html_response(500)
      }
  }
}

pub fn get_waitlist(req: Request) -> Response {
  use <- wisp.require_method(req, http.Get)

  ui.page()
  |> layout.layout
  |> element.to_document_string_builder
  |> wisp.html_response(200)
}
