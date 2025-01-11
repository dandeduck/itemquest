import decode/zero
import gleam/option.{type Option}
import pog

/// Insert a row into market_entries with (item_id)
///
/// > 🐿️ This function was generated automatically using v2.0.5 of
/// > the [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub fn insert_market_entry(db, arg_1) {
  let decoder = zero.map(zero.dynamic, fn(_) { Nil })

  let query = "-- Insert a row into market_entries with (item_id)
INSERT INTO market_entries (item_id)
VALUES ($1);
"

  pog.query(query)
  |> pog.parameter(pog.int(arg_1))
  |> pog.returning(zero.run(_, decoder))
  |> pog.execute(db)
}

/// A row you get from running the `select_market_entries` query
/// defined in `./src/itemquest/modules/market/sql/select_market_entries.sql`.
///
/// > 🐿️ This type definition was generated automatically using v2.0.5 of the
/// > [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub type SelectMarketEntriesRow {
  SelectMarketEntriesRow(
    name: String,
    image_url: String,
    quantity: Int,
    popularity: Int,
    price: Option(Int),
  )
}

/// Select market entries with (market_id, search, sort_by, sort_direction, limit, offset)
///
/// > 🐿️ This function was generated automatically using v2.0.5 of
/// > the [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub fn select_market_entries(db, arg_1, arg_2, arg_3, arg_4, arg_5, arg_6) {
  let decoder = {
    use name <- zero.field(0, zero.string)
    use image_url <- zero.field(1, zero.string)
    use quantity <- zero.field(2, zero.int)
    use popularity <- zero.field(3, zero.int)
    use price <- zero.field(4, zero.optional(zero.int))
    zero.success(
      SelectMarketEntriesRow(name:, image_url:, quantity:, popularity:, price:),
    )
  }

  let query = "-- Select market entries with (market_id, search, sort_by, sort_direction, limit, offset)
SELECT name, image_url, quantity, popularity, price
FROM market_entries 
WHERE market_id = $1 AND CASE WHEN $2 != '' THEN name_search @@ to_tsquery($2) ELSE TRUE END
ORDER BY 
    (CASE WHEN $4 = 'ASC' AND $3 = 'popularity' THEN popularity END) ASC,
    (CASE WHEN $4 = 'DESC' AND $3 = 'popularity' THEN popularity END) DESC,
    (CASE WHEN $4 = 'ASC' AND $3 = 'price' THEN price END) ASC NULLS FIRST,
    (CASE WHEN $4 = 'DESC' AND $3 = 'price' THEN price END) DESC NULLS LAST,
    (CASE WHEN $4 = 'ASC' AND $3 = 'quantity' THEN quantity END) ASC,
    (CASE WHEN $4 = 'DESC' AND $3 = 'quantity' THEN quantity END) DESC
LIMIT $5 OFFSET $6;
"

  pog.query(query)
  |> pog.parameter(pog.int(arg_1))
  |> pog.parameter(pog.text(arg_2))
  |> pog.parameter(pog.text(arg_3))
  |> pog.parameter(pog.text(arg_4))
  |> pog.parameter(pog.int(arg_5))
  |> pog.parameter(pog.int(arg_6))
  |> pog.returning(zero.run(_, decoder))
  |> pog.execute(db)
}

/// A row you get from running the `select_market` query
/// defined in `./src/itemquest/modules/market/sql/select_market.sql`.
///
/// > 🐿️ This type definition was generated automatically using v2.0.5 of the
/// > [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub type SelectMarketRow {
  SelectMarketRow(
    market_id: Int,
    status: MarketStatus,
    name: String,
    image_url: Option(String),
    created_at: Option(pog.Timestamp),
  )
}

/// Runs the `select_market` query
/// defined in `./src/itemquest/modules/market/sql/select_market.sql`.
///
/// > 🐿️ This function was generated automatically using v2.0.5 of
/// > the [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub fn select_market(db, arg_1) {
  let decoder = {
    use market_id <- zero.field(0, zero.int)
    use status <- zero.field(1, market_status_decoder())
    use name <- zero.field(2, zero.string)
    use image_url <- zero.field(3, zero.optional(zero.string))
    use created_at <- zero.field(4, zero.optional(timestamp_decoder()))
    zero.success(
      SelectMarketRow(market_id:, status:, name:, image_url:, created_at:),
    )
  }

  let query = "SELECT * FROM markets WHERE market_id = $1
"

  pog.query(query)
  |> pog.parameter(pog.int(arg_1))
  |> pog.returning(zero.run(_, decoder))
  |> pog.execute(db)
}

// --- Enums -------------------------------------------------------------------

/// Corresponds to the Postgres `market_status` enum.
///
/// > 🐿️ This type definition was generated automatically using v2.0.5 of the
/// > [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub type MarketStatus {
  Development
  Live
}

fn market_status_decoder() {
  use variant <- zero.then(zero.string)
  case variant {
    "development" -> zero.success(Development)
    "live" -> zero.success(Live)
    _ -> zero.failure(Development, "MarketStatus")
  }
}

// --- Encoding/decoding utils -------------------------------------------------

/// A decoder to decode `timestamp`s coming from a Postgres query.
///
fn timestamp_decoder() {
  use dynamic <- zero.then(zero.dynamic)
  case pog.decode_timestamp(dynamic) {
    Ok(timestamp) -> zero.success(timestamp)
    Error(_) -> {
      let date = pog.Date(0, 0, 0)
      let time = pog.Time(0, 0, 0, 0)
      zero.failure(pog.Timestamp(date:, time:), "timestamp")
    }
  }
}
