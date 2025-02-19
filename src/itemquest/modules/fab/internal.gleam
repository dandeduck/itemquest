import gleam/int
import itemquest/modules/fab/sql
import itemquest/utils/ids.{type Uuid}
import itemquest/web/contexts.{type RequestContext}
import itemquest/web/errors.{type InternalError}

pub fn create_item(
  ctx: RequestContext,
  market_id: Int,
  name: String,
) -> Result(Int, InternalError(Nil)) {
  use _, rows <- errors.try_query(sql.insert_item(ctx.db, market_id, name), ctx)
  let assert [row] = rows

  Ok(row.item_id)
}

pub type UpdateItemInstanceError {
  NotFound
}

pub fn update_item_instance_owner(
  item_instance_id: Int,
  owner owner_user_id: Uuid,
  new_owner new_user_id: Uuid,
  ctx ctx: RequestContext,
) -> Result(Nil, InternalError(UpdateItemInstanceError)) {
  use _, rows <- errors.try_query(
    sql.update_item_instance_user_id(
      ctx.db,
      item_instance_id,
      owner_user_id,
      new_user_id,
    ),
    ctx,
  )

  case rows {
    [_] -> Ok(Nil)
    _ ->
      NotFound
      |> errors.Business(
        "Item instace "
          <> int.to_string(item_instance_id)
          <> " belonging to user "
          <> ids.format(owner_user_id)
          <> " wasn't found",
        _,
      )
      |> Error
  }
}
