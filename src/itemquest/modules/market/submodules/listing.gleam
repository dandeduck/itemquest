import itemquest/modules/market/submodules/listing/controller
import itemquest/web/contexts.{type RequestContext}
import wisp.{type Request, type Response}

pub fn handle_request(
  listing_id listing_id: Int,
  segments relative_segments: List(String),
  req _req: Request,
  ctx ctx: RequestContext,
) -> Response {
  case relative_segments {
    ["buy"] -> controller.post_buy_listing(listing_id, ctx)
    _ -> wisp.not_found()
  }
}
