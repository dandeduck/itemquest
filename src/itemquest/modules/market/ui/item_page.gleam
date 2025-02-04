import gleam/erlang
import gleam/int
import gleam/list
import gleam/option
import gleam/string
import itemquest/modules/market/sql.{
  type SelectItemPricesRow, type SelectMarketItemRow,
}
import itemquest/utils/ui
import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html

const prices_id = "prices"

pub fn page(item: SelectMarketItemRow) -> Element(a) {
  html.section([], [
    html.header([attribute.class("mb-20 flex gap-12")], [
      html.div([], [
        html.h1([attribute.class("text-3xl mb-2")], [html.text(item.name)]),
        html.img([attribute.class("w-64 h-64"), attribute.src(item.image_url)]),
      ]),
      ui.eager_loading_frame(
        [attribute.id(prices_id), attribute.class("flex-1")],
        load_from: int.to_string(item.item_id) <> "/prices",
      ),
    ]),
  ])
}

pub fn prices(
  rows: List(SelectItemPricesRow),
) -> Element(a) {
  let js_values =
    rows
    |> list.map(fn(row) {
      "{value:["
      <> int.to_string(row.timestamp)
      <> "000,"
      <> ui.get_string_price(row.price)
      <> "]}"
    })
  let js_data =
    "[" <> string.join(js_values, ",") <> "]"
  let js_string =
    "
  import charts from '@itemquest/charts'

  charts.initTimeChart('prices_chart', %data%)
  "

  ui.turbo_frame([attribute.id(prices_id)], [
    html.div(
      [attribute.id("prices_chart"), attribute.class("w-full h-full")],
      [],
    ),
    html.script(
      [attribute.type_("module")],
      string.replace(js_string, each: "%data%", with: js_data),
    ),
  ])
}

pub fn listings() -> Element(a) {
}
