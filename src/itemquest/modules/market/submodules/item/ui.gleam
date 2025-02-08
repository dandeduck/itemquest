import gleam/int
import gleam/list
import gleam/option
import gleam/string
import itemquest/modules/market/submodules/item/sql.{
  type SelectItemPricesRow, type SelectItemSellListingsRow,
  type SelectMarketItemRow,
}
import itemquest/utils/ui
import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html

const prices_id = "prices"

const listings_id = "listings"

pub fn page(item: SelectMarketItemRow) -> Element(a) {
  html.section([], [
    html.header([attribute.class("mb-20 flex flex-col md:flex-row gap-12")], [
      html.div([], [
        html.h1([attribute.class("text-3xl mb-2")], [html.text(item.name)]),
        html.img([
          attribute.class("w-64 h-64 rounded-lg"),
          attribute.src(item.image_url),
        ]),
      ]),
      ui.eager_loading_frame(
        [attribute.id(prices_id), attribute.class("flex-1")],
        load_from: int.to_string(item.item_id) <> "/prices",
      ),
    ]),
    html.h2([attribute.class("text-2xl mb-5")], [html.text("Listings")]),
    ui.eager_loading_frame(
      [attribute.id(listings_id)],
      load_from: int.to_string(item.item_id) <> "/listings",
    ),
  ])
}

pub fn prices(rows: List(SelectItemPricesRow)) -> Element(a) {
  let js_values =
    rows
    |> list.map(fn(row) {
      "{value:["
      <> int.to_string(row.timestamp)
      <> "000,"
      <> ui.get_string_price(row.price)
      <> "]}"
    })
  let js_data = "[" <> string.join(js_values, ",") <> "]"
  let js_string =
    "
  import charts from '@itemquest/charts'

  charts.initTimeChart('prices_chart', %data%)
  "

  ui.turbo_frame([attribute.id(prices_id)], [
    html.div(
      [attribute.id("prices_chart"), attribute.class("w-full h-64 md:h-full")],
      [],
    ),
    html.script(
      [attribute.type_("module")],
      string.replace(js_string, each: "%data%", with: js_data),
    ),
  ])
}

pub fn listings(listings: List(SelectItemSellListingsRow)) -> Element(a) {
  ui.turbo_frame(
    [attribute.id(listings_id), attribute.class("flex flex-col gap-4 w-full")],
    listings |> list.map(listing_row),
  )
}

fn listing_row(listing_row: SelectItemSellListingsRow) -> Element(a) {
  // those shouldn't be options
  let assert option.Some(avatar) = listing_row.avatar_image_url
  let assert option.Some(user_name) = listing_row.name

  html.div(
    [attribute.class("grid grid-cols-[50px_1fr_50px_75px] gap-5 items-center")],
    [
      html.img([attribute.src(avatar), attribute.class("rounded-full")]),
      html.p([], [html.text(user_name)]),
      html.p([], [html.text(ui.get_string_price(listing_row.price))]),
      html.button([], [html.text("Buy")]),
    ],
  )
}
