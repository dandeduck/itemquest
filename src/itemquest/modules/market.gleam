import itemquest/modules/market/ui
import gleam/http
import itemquest/modules/market/sql.{type SelectTemplateMarketEntriesRow}
import itemquest/utils/handling
import itemquest/utils/ui/layout
import itemquest/web/contexts.{type RequestContext}
import itemquest/web/errors.{type InternalError}
import lustre/element
import pog
import wisp.{type Request, type Response}

pub fn handle_get_market_by_id(
  market_id: String,
  req: Request,
  _ctx: RequestContext,
) -> Response {
  use <- wisp.require_method(req, http.Get)

  let query = wisp.get_query(req)
  use _sort_by <- handling.require_query_key(query, "sort_by")
  use _limit <- handling.require_query_key(query, "limit")
  use _offset <- handling.require_query_key(query, "offset")

  ui.page("Market " <> market_id)
  |> layout.layout
  |> element.to_document_string_builder
  |> wisp.html_response(200)
}

fn select_market_entries(
  ctx: RequestContext,
  sort_by: String,
  limit: Int,
  offset: Int,
) -> Result(List(SelectTemplateMarketEntriesRow), InternalError(t)) {
  case sql.select_template_market_entries(ctx.db, sort_by, limit, offset) {
    Ok(pog.Returned(_, rows)) -> Ok(rows)
    Error(error) -> error |> errors.from_query_error |> Error
  }
}
