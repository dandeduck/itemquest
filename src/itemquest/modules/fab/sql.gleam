import decode/zero
import pog

/// A row you get from running the `insert_template` query
/// defined in `./src/itemquest/modules/fab/sql/insert_template.sql`.
///
/// > 🐿️ This type definition was generated automatically using v2.0.5 of the
/// > [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub type InsertTemplateRow {
  InsertTemplateRow(template_id: Int)
}

/// Runs the `insert_template` query
/// defined in `./src/itemquest/modules/fab/sql/insert_template.sql`.
///
/// > 🐿️ This function was generated automatically using v2.0.5 of
/// > the [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub fn insert_template(db, arg_1) {
  let decoder = {
    use template_id <- zero.field(0, zero.int)
    zero.success(InsertTemplateRow(template_id:))
  }

  let query = "INSERT INTO templates (name) VALUES ($1) RETURNING template_id
"

  pog.query(query)
  |> pog.parameter(pog.text(arg_1))
  |> pog.returning(zero.run(_, decoder))
  |> pog.execute(db)
}
