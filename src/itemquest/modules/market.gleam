import itemquest/modules/market/sql.{type SelectTemplateMarketEntriesRow}
import itemquest/web/contexts.{type RequestContext}
import itemquest/web/errors.{type InternalError}
import pog

pub fn create_market_entry(
  ctx: RequestContext,
  template_id: Int,
) -> Result(Nil, InternalError(t)) {
  case sql.insert_template_market_entry(ctx.db, template_id) {
    Ok(_) -> Ok(Nil)
    Error(error) -> error |> errors.from_query_error |> Error
  }
}

pub fn select_market_entries(
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
