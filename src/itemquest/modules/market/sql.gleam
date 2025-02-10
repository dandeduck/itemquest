import gleam/dynamic/decode
import gleam/option.{type Option}
import pog

/// A row you get from running the `select_market_item_names` query
/// defined in `./src/itemquest/modules/market/sql/select_market_item_names.sql`.
///
/// > 🐿️ This type definition was generated automatically using v3.0.0 of the
/// > [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub type SelectMarketItemNamesRow {
  SelectMarketItemNamesRow(name: String, rank: Float)
}

/// Select market item names with (name)
///
/// > 🐿️ This function was generated automatically using v3.0.0 of
/// > the [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub fn select_market_item_names(db, arg_1, arg_2) {
  let decoder = {
    use name <- decode.field(0, decode.string)
    use rank <- decode.field(1, decode.float)
    decode.success(SelectMarketItemNamesRow(name:, rank:))
  }

  let query =
    "
-- Select market item names with (name)
SELECT name, ts_rank(name_search, to_tsquery($2)) as rank
FROM market_items 
WHERE market_id = $1 AND name_search @@ to_tsquery($2)
ORDER BY rank DESC
LIMIT 10;
"

  pog.query(query)
  |> pog.parameter(pog.int(arg_1))
  |> pog.parameter(pog.text(arg_2))
  |> pog.returning(decoder)
  |> pog.execute(db)
}

/// A row you get from running the `select_market` query
/// defined in `./src/itemquest/modules/market/sql/select_market.sql`.
///
/// > 🐿️ This type definition was generated automatically using v3.0.0 of the
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
/// > 🐿️ This function was generated automatically using v3.0.0 of
/// > the [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub fn select_market(db, arg_1) {
  let decoder = {
    use market_id <- decode.field(0, decode.int)
    use status <- decode.field(1, market_status_decoder())
    use name <- decode.field(2, decode.string)
    use image_url <- decode.field(3, decode.optional(decode.string))
    use created_at <- decode.field(4, decode.optional(pog.timestamp_decoder()))
    decode.success(SelectMarketRow(
      market_id:,
      status:,
      name:,
      image_url:,
      created_at:,
    ))
  }

  let query =
    "SELECT * FROM markets WHERE market_id = $1
"

  pog.query(query)
  |> pog.parameter(pog.int(arg_1))
  |> pog.returning(decoder)
  |> pog.execute(db)
}

/// A row you get from running the `select_market_items` query
/// defined in `./src/itemquest/modules/market/sql/select_market_items.sql`.
///
/// > 🐿️ This type definition was generated automatically using v3.0.0 of the
/// > [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub type SelectMarketItemsRow {
  SelectMarketItemsRow(
    item_id: Int,
    name: String,
    image_url: String,
    quantity: Int,
    popularity: Int,
    price: Option(Int),
  )
}

/// Select market items with (market_id, search, sort_by, sort_direction, limit, offset)
///
/// > 🐿️ This function was generated automatically using v3.0.0 of
/// > the [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub fn select_market_items(db, arg_1, arg_2, arg_3, arg_4, arg_5, arg_6) {
  let decoder = {
    use item_id <- decode.field(0, decode.int)
    use name <- decode.field(1, decode.string)
    use image_url <- decode.field(2, decode.string)
    use quantity <- decode.field(3, decode.int)
    use popularity <- decode.field(4, decode.int)
    use price <- decode.field(5, decode.optional(decode.int))
    decode.success(SelectMarketItemsRow(
      item_id:,
      name:,
      image_url:,
      quantity:,
      popularity:,
      price:,
    ))
  }

  let query =
    "-- Select market items with (market_id, search, sort_by, sort_direction, limit, offset)
SELECT item_id, name, image_url, quantity, popularity, price
FROM market_items 
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
  |> pog.returning(decoder)
  |> pog.execute(db)
}

// --- Enums -------------------------------------------------------------------

/// Corresponds to the Postgres `market_status` enum.
///
/// > 🐿️ This type definition was generated automatically using v3.0.0 of the
/// > [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub type MarketStatus {
  Development
  Live
}

fn market_status_decoder() {
  use variant <- decode.then(decode.string)
  case variant {
    "development" -> decode.success(Development)
    "live" -> decode.success(Live)
    _ -> decode.failure(Development, "MarketStatus")
  }
}
