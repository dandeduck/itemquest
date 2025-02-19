import gleam/dynamic/decode
import pog
import youid/uuid

/// A row you get from running the `insert_item` query
/// defined in `./src/itemquest/modules/fab/sql/insert_item.sql`.
///
/// > 🐿️ This type definition was generated automatically using v3.0.0 of the
/// > [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub type InsertItemRow {
  InsertItemRow(item_id: Int)
}

/// Runs the `insert_item` query
/// defined in `./src/itemquest/modules/fab/sql/insert_item.sql`.
///
/// > 🐿️ This function was generated automatically using v3.0.0 of
/// > the [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub fn insert_item(db, arg_1, arg_2) {
  let decoder = {
    use item_id <- decode.field(0, decode.int)
    decode.success(InsertItemRow(item_id:))
  }

  let query =
    "INSERT INTO items (market_id, name) VALUES ($1, $2) RETURNING item_id
"

  pog.query(query)
  |> pog.parameter(pog.int(arg_1))
  |> pog.parameter(pog.text(arg_2))
  |> pog.returning(decoder)
  |> pog.execute(db)
}

/// Runs the `update_item_instance_user_id` query
/// defined in `./src/itemquest/modules/fab/sql/update_item_instance_user_id.sql`.
///
/// > 🐿️ This function was generated automatically using v3.0.0 of
/// > the [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub fn update_item_instance_user_id(db, arg_1, arg_2, arg_3) {
  let decoder = decode.map(decode.dynamic, fn(_) { Nil })

  let query =
    "UPDATE item_instances
SET user_id = $3
WHERE item_instance_id = $1 AND user_id = $2;
"

  pog.query(query)
  |> pog.parameter(pog.int(arg_1))
  |> pog.parameter(pog.text(uuid.to_string(arg_2)))
  |> pog.parameter(pog.text(uuid.to_string(arg_3)))
  |> pog.returning(decoder)
  |> pog.execute(db)
}
