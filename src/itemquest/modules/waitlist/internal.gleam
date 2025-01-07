import gleam/regexp.{type Regexp}
import gleam/result
import itemquest/modules/waitlist/sql
import itemquest/web/contexts.{type RequestContext}
import itemquest/web/errors.{type InternalError}
import pog

pub type WaitlistErrorCode {
  EmailAlreadyAdded
}

const remove_plus_exp_string = "\\+.*?(?=@)"

pub fn add_waitlist_email(
  ctx: RequestContext,
  address: String,
) -> Result(Nil, InternalError(WaitlistErrorCode)) {
  use remove_plus_exp <- result.try(regexp_from_string(remove_plus_exp_string))
  let address = regexp.replace(remove_plus_exp, in: address, with: "")

  case sql.insert_waitlist_email(ctx.db, address) {
    Ok(_) -> Ok(Nil)
    Error(error) -> {
      case error {
        pog.ConstraintViolated(_, _, _) ->
          EmailAlreadyAdded
          |> errors.Business("Email already added to the waitlist", _)
          |> Error
        _ -> error |> errors.from_query_error |> Error
      }
    }
  }
}

fn regexp_from_string(exp: String) -> Result(Regexp, InternalError(t)) {
  case regexp.from_string(exp) {
    Ok(exp) -> Ok(exp)
    Error(error) ->
      error.error
      |> errors.Operational
      |> Error
  }
}
