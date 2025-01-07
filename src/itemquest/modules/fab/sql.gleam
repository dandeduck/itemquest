import decode/zero
import pog

/// A row you get from running the `insert_item` query
/// defined in `./src/itemquest/modules/fab/sql/insert_item.sql`.
///
/// > 🐿️ This type definition was generated automatically using v2.0.5 of the
/// > [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub type InsertItemRow {
  InsertItemRow(item_id: Int)
}

/// Runs the `insert_item` query
/// defined in `./src/itemquest/modules/fab/sql/insert_item.sql`.
///
/// > 🐿️ This function was generated automatically using v2.0.5 of
/// > the [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub fn insert_item(db, arg_1, arg_2) {
  let decoder = {
    use item_id <- zero.field(0, zero.int)
    zero.success(InsertItemRow(item_id:))
  }

  let query = "INSERT INTO items (market_id, name) VALUES ($1, $2) RETURNING item_id
"

  pog.query(query)
  |> pog.parameter(pog.int(arg_1))
  |> pog.parameter(pog.text(arg_2))
  |> pog.returning(zero.run(_, decoder))
  |> pog.execute(db)
}
