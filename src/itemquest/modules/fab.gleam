import gleam/result
import itemquest/web/contexts.{type RequestContext}
import itemquest/web/errors.{type Error}
import itemquest/modules/fab/sql
import pog.{type QueryError}

pub fn create_template(
  ctx: RequestContext,
  name: String,
) -> Result(Int, Error) {
   let result = result.try(sql.insert_template(
    ctx.db,
    name,
  ))

  case result {
      // Ok(Returned(_, template_id) -> Ok(template_id)
      Error(error) -> OperationalError(error.)
  }
}
