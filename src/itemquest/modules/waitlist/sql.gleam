import decode/zero
import pog

/// Runs the `insert_waitlist_email` query
/// defined in `./src/itemquest/modules/waitlist/sql/insert_waitlist_email.sql`.
///
/// > 🐿️ This function was generated automatically using v2.0.5 of
/// > the [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub fn insert_waitlist_email(db, arg_1) {
  let decoder = zero.map(zero.dynamic, fn(_) { Nil })

  let query =
    "INSERT INTO waitlist_emails (address) VALUES ($1)
"

  pog.query(query)
  |> pog.parameter(pog.text(arg_1))
  |> pog.returning(zero.run(_, decoder))
  |> pog.execute(db)
}
