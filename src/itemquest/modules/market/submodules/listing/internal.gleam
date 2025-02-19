import gleam/result
import itemquest/modules/fab
import itemquest/modules/market/submodules/listing/sql.{
  type SelectMarketListingRow,
}
import itemquest/utils/ids.{type Uuid}
import itemquest/web/contexts.{type RequestContext}
import itemquest/web/errors.{type InternalError}

pub type ListingError {
  IncorrectType
  NotFound
}

pub fn buy_listing(
  user_id: Uuid,
  item_instance_id: Int,
  ctx: RequestContext,
) -> Result(Nil, InternalError(ListingError)) {
  use listing <- result.try(select_listing(item_instance_id, ctx))

  case listing.listing_type {
    sql.Sell -> {
      let _ = fab.update_item_instance_owner(item_instance_id, listing.user_id, user_id, ctx)
      Ok(Nil)
    }
    sql.Buy ->
      IncorrectType
      |> errors.Business("Tried to buy a sell listing, TODO", _)
      |> Error
  }
}

fn select_listing(
  item_instance_id: Int,
  ctx: RequestContext,
) -> Result(SelectMarketListingRow, InternalError(ListingError)) {
  use _, rows <- errors.try_query(
    sql.select_market_listing(ctx.db, item_instance_id),
    ctx,
  )

  case rows {
    [row] -> Ok(row)
    _ -> NotFound |> errors.Business("Listing not found", _) |> Error
  }
}
