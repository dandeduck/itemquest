import itemquest/modules/fab/sql
import itemquest/web/contexts.{type RequestContext}
import itemquest/web/errors.{type InternalError}
import pog

pub fn create_template(
  ctx: RequestContext,
  name: String,
) -> Result(Int, InternalError(t)) {
  case sql.insert_template(ctx.db, name) {
    Ok(pog.Returned(_, rows)) -> {
      let assert [row] = rows
      Ok(row.template_id)
    }
    Error(error) -> error |> errors.from_query_error |> Error
  }
}
