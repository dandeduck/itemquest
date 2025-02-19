import itemquest/utils/ids
import itemquest/utils/handling
import itemquest/modules/auth
import itemquest/modules/market/submodules/listing/internal
import itemquest/web/contexts.{type RequestContext}
import itemquest/web/errors
import wisp.{type Response}

pub fn post_buy_listing(
  listing_id: Int,
  ctx: RequestContext,
) -> Response {
  use user_id <- auth.require_platform_authorized(ctx)
  use user_id <- handling.require_ok_result(ids.parse_id(user_id))

  case internal.buy_listing(user_id, listing_id, ctx) {
    Ok(_) -> wisp.ok()
    //todo
    Error(errors.Operational(_)) -> wisp.internal_server_error()
    // todo - all such failures should trigger a snackbar
    Error(errors.Business(_, listing_error) as error) -> {
        errors.log_internal_error(error, ctx)
        case listing_error {
            internal.NotFound -> wisp.unprocessable_entity() // todo: push snackbar with "No longer available" or somethin
            _ -> wisp.bad_request()
        }
    }
  }
}
