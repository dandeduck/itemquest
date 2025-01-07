import itemquest/modules/market/sql
import itemquest/web/contexts.{type RequestContext}
import itemquest/web/errors.{type InternalError}

pub fn create_market_entry(
  template_id: Int,
  ctx: RequestContext,
) -> Result(Nil, InternalError(t)) {
  case sql.insert_template_market_entry(ctx.db, template_id) {
    Ok(_) -> Ok(Nil)
    Error(error) -> error |> errors.from_query_error |> Error
  }
}
