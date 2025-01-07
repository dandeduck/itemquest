import gleam/int
import gleam/list
import gleam/option
import itemquest/modules/market/sql.{
  type SelectMarketEntriesRow, type SelectMarketRow,
}
import itemquest/utils/ui
import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html

const market_rows_container_id = "market_rows_container"

pub fn page(market: SelectMarketRow, market_entries_uri: String) -> Element(t) {
  html.section([], [
    html.header([], [
      html.h1([attribute.class("color-black text-3xl mb-20")], [
        html.text(market.name),
      ]),
    ]),
    html.table([attribute.class("w-full")], [
      html.tbody([attribute.id(market_rows_container_id)], [
        html.tr([attribute.class("text-start")], [
          html.th([], [html.text("Image")]),
          html.th([], [html.text("Item name")]),
          html.th([], [html.text("Quantity")]),
          html.th([], [html.text("Popularity")]),
          html.th([], [html.text("Price")]),
        ]),
        ui.eager_loading_frame(
          [attribute.attribute("data-turbo-stream", "true")],
          id: "",
          // todo
          load_from: market_entries_uri,
        ),
      ]),
    ]),
  ])
}

pub fn market_rows(entries: List(SelectMarketEntriesRow)) -> Element(t) {
  case entries {
    [] -> [html.h2([], [html.text("No items, sorry!")])]
    // todo: fix me!
    _ -> list.map(entries, market_row)
  }
  |> ui.turbo_stream(ui.StreamAppend, market_rows_container_id, _)
}

fn market_row(entry: SelectMarketEntriesRow) -> Element(t) {
  html.tr([attribute.class("text-start")], [
    html.th([], [html.text("Image")]),
    html.th([], [html.text(entry.name)]),
    html.th([], [html.text(int.to_string(entry.quantity))]),
    html.th([], [html.text("0")]),
    html.th([], [
      html.text(case entry.price {
        option.Some(price) -> int.to_string(price)
        _ -> "-"
      }),
    ]),
  ])
}
