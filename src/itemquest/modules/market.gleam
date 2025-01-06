import itemquest/modules/market/sql.{type SelectTemplateMarketEntriesRow}
import itemquest/web/contexts.{type RequestContext}
import itemquest/web/errors.{type InternalError}
import pog

pub fn create_market_entry(
  ctx: RequestContext,
  template_id: Int,
) -> Result(Nil, InternalError) {
  case sql.insert_template_market_entry(ctx.db, template_id) {
    Ok(_) -> Ok(Nil)
    Error(error) -> errors.from_query_error(error)
  }
}

pub fn select_market_entries(
  ctx: RequestContext,
  sort_by: String,
  limit: Int,
  offset: Int,
) -> Result(List(SelectTemplateMarketEntriesRow), InternalError) {
  case sql.select_template_market_entries(ctx.db, sort_by, limit, offset) {
    Ok(pog.Returned(_, rows)) -> Ok(rows)
    Error(error) -> errors.from_query_error(error)
  }
}
