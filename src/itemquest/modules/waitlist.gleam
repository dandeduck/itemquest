import itemquest/modules/waitlist/sql
import itemquest/web/contexts.{type RequestContext}
import itemquest/web/errors.{type InternalError}
import pog

pub fn add_email(
  ctx: RequestContext,
  address: String,
) -> Result(Nil, InternalError) {
  case sql.insert_waitlist_email(ctx.db, address) {
    Ok(_) -> Ok(Nil)
    Error(error) -> {
      case error {
        pog.ConstraintViolated(_, _, _) -> todo
        _ -> errors.from_query_error(error)
      }
    }
  }
}
