import decode/zero
import gleam/option.{type Option}
import pog

/// A row you get from running the `find_template_market_entry` query
/// defined in `./src/itemquest/modules/market/sql/find_template_market_entry.sql`.
///
/// > 🐿️ This type definition was generated automatically using v2.0.5 of the
/// > [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub type FindTemplateMarketEntryRow {
  FindTemplateMarketEntryRow(
    template_id: Int,
    quantity: Option(Int),
    price: Option(Int),
    name: String,
  )
}

/// Find template market entry by template_id
///
/// > 🐿️ This function was generated automatically using v2.0.5 of
/// > the [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub fn find_template_market_entry(db, arg_1) {
  let decoder = {
    use template_id <- zero.field(0, zero.int)
    use quantity <- zero.field(1, zero.optional(zero.int))
    use price <- zero.field(2, zero.optional(zero.int))
    use name <- zero.field(3, zero.string)
    zero.success(
      FindTemplateMarketEntryRow(template_id:, quantity:, price:, name:),
    )
  }

  let query = "-- Find template market entry by template_id
SELECT template_market_entries.*, item_templates.name
FROM template_market_entries 
INNER JOIN item_templates ON template_market_entries.template_id=item_templates.template_id
WHERE template_market_entries.template_id = $1
"

  pog.query(query)
  |> pog.parameter(pog.int(arg_1))
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
