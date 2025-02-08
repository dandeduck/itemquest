import gleam/dynamic/decode
import gleam/option.{type Option}
import pog

/// A row you get from running the `select_market_item` query
/// defined in `./src/itemquest/modules/market/submodules/item/sql/select_market_item.sql`.
///
/// > 🐿️ This type definition was generated automatically using v3.0.0 of the
/// > [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub type SelectMarketItemRow {
  SelectMarketItemRow(
    item_id: Int,
    name: String,
    image_url: String,
    price: Option(Int),
  )
}

/// Runs the `select_market_item` query
/// defined in `./src/itemquest/modules/market/submodules/item/sql/select_market_item.sql`.
///
/// > 🐿️ This function was generated automatically using v3.0.0 of
/// > the [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub fn select_market_item(db, arg_1, arg_2) {
  let decoder = {
    use item_id <- decode.field(0, decode.int)
    use name <- decode.field(1, decode.string)
    use image_url <- decode.field(2, decode.string)
    use price <- decode.field(3, decode.optional(decode.int))
    decode.success(SelectMarketItemRow(item_id:, name:, image_url:, price:))
  }

  let query =
    "SELECT item_id, name, image_url, price
FROM market_items
WHERE item_id = $1 AND market_id = $2;
"

  pog.query(query)
  |> pog.parameter(pog.int(arg_1))
  |> pog.parameter(pog.int(arg_2))
  |> pog.returning(decoder)
  |> pog.execute(db)
}

/// A row you get from running the `select_item_sell_listings` query
/// defined in `./src/itemquest/modules/market/submodules/item/sql/select_item_sell_listings.sql`.
///
/// > 🐿️ This type definition was generated automatically using v3.0.0 of the
/// > [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub type SelectItemSellListingsRow {
  SelectItemSellListingsRow(
    price: Int,
    avatar_image_url: Option(String),
    name: Option(String),
  )
}

/// Runs the `select_item_sell_listings` query
/// defined in `./src/itemquest/modules/market/submodules/item/sql/select_item_sell_listings.sql`.
///
/// > 🐿️ This function was generated automatically using v3.0.0 of
/// > the [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub fn select_item_sell_listings(db, arg_1, arg_2, arg_3) {
  let decoder = {
    use price <- decode.field(0, decode.int)
    use avatar_image_url <- decode.field(1, decode.optional(decode.string))
    use name <- decode.field(2, decode.optional(decode.string))
    decode.success(SelectItemSellListingsRow(price:, avatar_image_url:, name:))
  }

  let query =
    "SELECT price, avatar_image_url, name
FROM market_listings
LEFT JOIN users ON market_listings.user_id = users.user_id
WHERE item_id = $1 AND listing_type = 'sell'
ORDER BY market_listings.price DESC
LIMIT $2 OFFSET $3;
"

  pog.query(query)
  |> pog.parameter(pog.int(arg_1))
  |> pog.parameter(pog.int(arg_2))
  |> pog.parameter(pog.int(arg_3))
  |> pog.returning(decoder)
  |> pog.execute(db)
}

/// A row you get from running the `select_item_prices` query
/// defined in `./src/itemquest/modules/market/submodules/item/sql/select_item_prices.sql`.
///
/// > 🐿️ This type definition was generated automatically using v3.0.0 of the
/// > [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub type SelectItemPricesRow {
  SelectItemPricesRow(price: Int, timestamp: Int)
}

/// Interval can be 'max', 'hour', 'day'. Based on this runs on the relevant view/table
///
/// > 🐿️ This function was generated automatically using v3.0.0 of
/// > the [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub fn select_item_prices(db, arg_1, arg_2) {
  let decoder = {
    use price <- decode.field(0, decode.int)
    use timestamp <- decode.field(1, decode.int)
    decode.success(SelectItemPricesRow(price:, timestamp:))
  }

  let query =
    "-- Interval can be 'max', 'hour', 'day'. Based on this runs on the relevant view/table
(
    SELECT price, extract(epoch from time)::int as timestamp
    FROM market_sales
    WHERE $2 = 'max' AND item_id = $1 AND time >= NOW() - INTERVAL '30 day' -- todo fix this to 1 day(?)
    UNION ALL 
    SELECT price, extract(epoch from time)::int as timestamp
    FROM hourly_item_prices
    WHERE $2 = 'hour' AND item_id = $1
    UNION ALL  
    SELECT price, extract(epoch from time)::int as timestamp 
    FROM daily_item_prices
    WHERE $2 = 'day' AND item_id = $1
    ORDER BY timestamp
)
UNION ALL
SELECT price, extract(epoch from CURRENT_TIMESTAMP)::int as timestamp
FROM market_items
WHERE $2 != 'max' AND item_id = $1 AND price IS NOT NULL;
"

  pog.query(query)
  |> pog.parameter(pog.int(arg_1))
  |> pog.parameter(pog.text(arg_2))
  |> pog.returning(decoder)
  |> pog.execute(db)
}
