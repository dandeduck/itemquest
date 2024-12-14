import gleam/result
import itemquest/contexts.{type RequestContext}
import itemquest/modules/market/sql
import pog.{type QueryError}

pub fn create_market_entry(
  ctx: RequestContext,
  template_id: In,
) -> Result(Nil, QueryError) {
  use _ <- result.try(sql.insert_template_market_entry(ctx.db, template_id))

  Ok(Nil)
}
