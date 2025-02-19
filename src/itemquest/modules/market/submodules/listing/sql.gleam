import gleam/dynamic/decode
import pog
import youid/uuid.{type Uuid}

/// A row you get from running the `select_market_listing` query
/// defined in `./src/itemquest/modules/market/submodules/listing/sql/select_market_listing.sql`.
///
/// > 🐿️ This type definition was generated automatically using v3.0.0 of the
/// > [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub type SelectMarketListingRow {
  SelectMarketListingRow(price: Int, user_id: Uuid, listing_type: ListingType)
}

/// Runs the `select_market_listing` query
/// defined in `./src/itemquest/modules/market/submodules/listing/sql/select_market_listing.sql`.
///
/// > 🐿️ This function was generated automatically using v3.0.0 of
/// > the [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub fn select_market_listing(db, arg_1) {
  let decoder = {
    use price <- decode.field(0, decode.int)
    use user_id <- decode.field(1, uuid_decoder())
    use listing_type <- decode.field(2, listing_type_decoder())
    decode.success(SelectMarketListingRow(price:, user_id:, listing_type:))
  }

  let query =
    "SELECT price, user_id, listing_type
FROM market_listings
WHERE item_instance_id = $1;
"

  pog.query(query)
  |> pog.parameter(pog.int(arg_1))
  |> pog.returning(decoder)
  |> pog.execute(db)
}

/// Runs the `delete_market_listing` query
/// defined in `./src/itemquest/modules/market/submodules/listing/sql/delete_market_listing.sql`.
///
/// > 🐿️ This function was generated automatically using v3.0.0 of
/// > the [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub fn delete_market_listing(db, arg_1) {
  let decoder = decode.map(decode.dynamic, fn(_) { Nil })

  let query =
    "DELETE FROM market_listings 
WHERE item_instance_id = $1;
"

  pog.query(query)
  |> pog.parameter(pog.int(arg_1))
  |> pog.returning(decoder)
  |> pog.execute(db)
}

// --- Enums -------------------------------------------------------------------

/// Corresponds to the Postgres `listing_type` enum.
///
/// > 🐿️ This type definition was generated automatically using v3.0.0 of the
/// > [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub type ListingType {
  Sell
  Buy
}

fn listing_type_decoder() {
  use variant <- decode.then(decode.string)
  case variant {
    "sell" -> decode.success(Sell)
    "buy" -> decode.success(Buy)
    _ -> decode.failure(Sell, "ListingType")
  }
}

// --- Encoding/decoding utils -------------------------------------------------

/// A decoder to decode `Uuid`s coming from a Postgres query.
///
fn uuid_decoder() {
  use bit_array <- decode.then(decode.bit_array)
  case uuid.from_bit_array(bit_array) {
    Ok(uuid) -> decode.success(uuid)
    Error(_) -> decode.failure(uuid.v7(), "uuid")
  }
}
