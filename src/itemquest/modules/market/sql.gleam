import decode/zero
import gleam/option.{type Option}
import pog

/// A row you get from running the `select_market_item` query
/// defined in `./src/itemquest/modules/market/sql/select_market_item.sql`.
///
/// > 🐿️ This type definition was generated automatically using v2.0.5 of the
/// > [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub type SelectMarketItemRow {
  SelectMarketItemRow(name: String, image_url: String, price: Option(Int))
}

/// Runs the `select_market_item` query
/// defined in `./src/itemquest/modules/market/sql/select_market_item.sql`.
///
/// > 🐿️ This function was generated automatically using v2.0.5 of
/// > the [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub fn select_market_item(db, arg_1) {
  let decoder = {
    use name <- zero.field(0, zero.string)
    use image_url <- zero.field(1, zero.string)
    use price <- zero.field(2, zero.optional(zero.int))
    zero.success(SelectMarketItemRow(name:, image_url:, price:))
  }

  let query = "SELECT name, image_url, price
FROM market_items
WHERE item_id = $1;
"

  pog.query(query)
  |> pog.parameter(pog.int(arg_1))
  |> pog.returning(zero.run(_, decoder))
  |> pog.execute(db)
}

/// A row you get from running the `select_market_item_names` query
/// defined in `./src/itemquest/modules/market/sql/select_market_item_names.sql`.
///
/// > 🐿️ This type definition was generated automatically using v2.0.5 of the
/// > [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub type SelectMarketItemNamesRow {
  SelectMarketItemNamesRow(name: String, rank: Float)
}

/// Select market item names with (name)
///
/// > 🐿️ This function was generated automatically using v2.0.5 of
/// > the [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub fn select_market_item_names(db, arg_1, arg_2) {
  let decoder = {
    use name <- zero.field(0, zero.string)
    use rank <- zero.field(1, zero.float)
    zero.success(SelectMarketItemNamesRow(name:, rank:))
  }

  let query = "
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
  |> pog.returning(zero.run(_, decoder))
  |> pog.execute(db)
}

/// A row you get from running the `select_hourly_item_prices` query
/// defined in `./src/itemquest/modules/market/sql/select_hourly_item_prices.sql`.
///
/// > 🐿️ This type definition was generated automatically using v2.0.5 of the
/// > [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub type SelectHourlyItemPricesRow {
  SelectHourlyItemPricesRow(price: Option(Int), time: Option(pog.Timestamp))
}

/// Selects all price+time rows by (item_id) using hourly_item_prices view
///
/// > 🐿️ This function was generated automatically using v2.0.5 of
/// > the [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub fn select_hourly_item_prices(db, arg_1) {
  let decoder = {
    use price <- zero.field(0, zero.optional(zero.int))
    use time <- zero.field(1, zero.optional(timestamp_decoder()))
    zero.success(SelectHourlyItemPricesRow(price:, time:))
  }

  let query = "-- Selects all price+time rows by (item_id) using hourly_item_prices view
SELECT price, time
FROM hourly_item_prices
WHERE item_id = $1;
"

  pog.query(query)
  |> pog.parameter(pog.int(arg_1))
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

/// A row you get from running the `select_market_items` query
/// defined in `./src/itemquest/modules/market/sql/select_market_items.sql`.
///
/// > 🐿️ This type definition was generated automatically using v2.0.5 of the
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
/// > 🐿️ This function was generated automatically using v2.0.5 of
/// > the [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub fn select_market_items(db, arg_1, arg_2, arg_3, arg_4, arg_5, arg_6) {
  let decoder = {
    use item_id <- zero.field(0, zero.int)
    use name <- zero.field(1, zero.string)
    use image_url <- zero.field(2, zero.string)
    use quantity <- zero.field(3, zero.int)
    use popularity <- zero.field(4, zero.int)
    use price <- zero.field(5, zero.optional(zero.int))
    zero.success(
      SelectMarketItemsRow(
        item_id:,
        name:,
        image_url:,
        quantity:,
        popularity:,
        price:,
      ),
    )
  }

  let query = "-- Select market items with (market_id, search, sort_by, sort_direction, limit, offset)
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
  |> pog.returning(zero.run(_, decoder))
  |> pog.execute(db)
}

/// A row you get from running the `select_daily_item_prices` query
/// defined in `./src/itemquest/modules/market/sql/select_daily_item_prices.sql`.
///
/// > 🐿️ This type definition was generated automatically using v2.0.5 of the
/// > [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub type SelectDailyItemPricesRow {
  SelectDailyItemPricesRow(price: Option(Int), time: Option(pog.Timestamp))
}

/// Selects all price+time rows by (item_id) using daily_item_prices view
///
/// > 🐿️ This function was generated automatically using v2.0.5 of
/// > the [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub fn select_daily_item_prices(db, arg_1) {
  let decoder = {
    use price <- zero.field(0, zero.optional(zero.int))
    use time <- zero.field(1, zero.optional(timestamp_decoder()))
    zero.success(SelectDailyItemPricesRow(price:, time:))
  }

  let query = "-- Selects all price+time rows by (item_id) using daily_item_prices view
SELECT price, time
FROM daily_item_prices
WHERE item_id = $1;
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
