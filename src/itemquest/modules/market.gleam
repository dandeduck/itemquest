import itemquest/web/errors.{type InternalError}
import itemquest/web/contexts.{type RequestContext}
import itemquest/modules/market/sql

pub fn create_market_entry(
  ctx: RequestContext,
  template_id: Int,
) -> Result(Nil, InternalError) {
  let result = sql.insert_template_market_entry(ctx.db, template_id)

  case result {
      Ok(_) -> Ok(Nil)
      Error(error) -> errors.from_query_error(error)
  }
}
