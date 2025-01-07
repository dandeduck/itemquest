import itemquest/modules/fab/sql
import itemquest/web/contexts.{type RequestContext}
import itemquest/web/errors.{type InternalError}

pub fn create_item(
  ctx: RequestContext,
  market_id: Int,
  name: String,
) -> Result(Int, InternalError(t)) {
  use _, rows <- errors.try_query(sql.insert_item(ctx.db, market_id, name))
  let assert [row] = rows

  Ok(row.item_id)
}
