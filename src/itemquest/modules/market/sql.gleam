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
    item_id: Int,
    quantity: Int,
    price: Option(Int),
    name: String,
    image_url: Option(String),
  )
}

/// Select market entries with (market_id, sort_by, limit, offset)
///
/// > 🐿️ This function was generated automatically using v2.0.5 of
/// > the [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub fn select_market_entries(db, arg_1, arg_2, arg_3, arg_4) {
  let decoder = {
    use item_id <- zero.field(0, zero.int)
    use quantity <- zero.field(1, zero.int)
    use price <- zero.field(2, zero.optional(zero.int))
    use name <- zero.field(3, zero.string)
    use image_url <- zero.field(4, zero.optional(zero.string))
    zero.success(
      SelectMarketEntriesRow(item_id:, quantity:, price:, name:, image_url:),
    )
  }

  let query = "-- Select market entries with (market_id, sort_by, limit, offset)
SELECT market_entries.*, items.name, items.image_url
FROM items 
INNER JOIN market_entries ON items.item_id=market_entries.item_id
WHERE items.market_id = $1
ORDER BY $2
LIMIT $3 OFFSET $4;
"

  pog.query(query)
  |> pog.parameter(pog.int(arg_1))
  |> pog.parameter(pog.text(arg_2))
  |> pog.parameter(pog.int(arg_3))
  |> pog.parameter(pog.int(arg_4))
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
