import decode/zero
import gleam/option.{type Option}
import pog

/// A row you get from running the `select_template_market_entries` query
/// defined in `./src/itemquest/modules/market/sql/select_template_market_entries.sql`.
///
/// > 🐿️ This type definition was generated automatically using v2.0.5 of the
/// > [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub type SelectTemplateMarketEntriesRow {
  SelectTemplateMarketEntriesRow(
    template_id: Int,
    quantity: Int,
    price: Option(Int),
    name: String,
    image_url: Option(String),
  )
}

/// Select template market entries with (sort_by, limit, offset)
///
/// > 🐿️ This function was generated automatically using v2.0.5 of
/// > the [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub fn select_template_market_entries(db, arg_1, arg_2, arg_3) {
  let decoder = {
    use template_id <- zero.field(0, zero.int)
    use quantity <- zero.field(1, zero.int)
    use price <- zero.field(2, zero.optional(zero.int))
    use name <- zero.field(3, zero.string)
    use image_url <- zero.field(4, zero.optional(zero.string))
    zero.success(
      SelectTemplateMarketEntriesRow(
        template_id:,
        quantity:,
        price:,
        name:,
        image_url:,
      ),
    )
  }

  let query = "-- Select template market entries with (sort_by, limit, offset)
SELECT template_market_entries.*, templates.name, templates.image_url
FROM template_market_entries 
INNER JOIN templates ON template_market_entries.template_id=templates.template_id
ORDER BY $1
LIMIT $2 OFFSET $3;
"

  pog.query(query)
  |> pog.parameter(pog.text(arg_1))
  |> pog.parameter(pog.int(arg_2))
  |> pog.parameter(pog.int(arg_3))
  |> pog.returning(zero.run(_, decoder))
  |> pog.execute(db)
}

/// Runs the `insert_template_market_entry` query
/// defined in `./src/itemquest/modules/market/sql/insert_template_market_entry.sql`.
///
/// > 🐿️ This function was generated automatically using v2.0.5 of
/// > the [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub fn insert_template_market_entry(db, arg_1) {
  let decoder = zero.map(zero.dynamic, fn(_) { Nil })

  let query = "INSERT INTO template_market_entries (template_id)
VALUES ($1)
"

  pog.query(query)
  |> pog.parameter(pog.int(arg_1))
  |> pog.returning(zero.run(_, decoder))
  |> pog.execute(db)
}
