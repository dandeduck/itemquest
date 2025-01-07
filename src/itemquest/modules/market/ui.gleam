import gleam/int
import gleam/list
import gleam/option
import itemquest/modules/market/sql.{
  type SelectMarketEntriesRow, type SelectMarketRow,
}
import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html

pub fn page(
  market: SelectMarketRow,
  entries: List(SelectMarketEntriesRow),
) -> Element(t) {
  html.section([], [
    html.header([], [
      html.h1([attribute.class("color-black text-3xl mb-20")], [
        html.text(market.name),
      ]),
    ]),
    html.table([attribute.class("w-full")], [
      html.tr([attribute.class("text-start")], [
        html.th([], [html.text("Image")]),
        html.th([], [html.text("Item name")]),
        html.th([], [html.text("Quantity")]),
        html.th([], [html.text("Popularity")]),
        html.th([], [html.text("Price")]),
      ]),
      ..market_rows(entries)
    ]),
  ])
}

fn market_rows(entries: List(SelectMarketEntriesRow)) -> List(Element(t)) {
  case entries {
    [] -> [html.h2([], [html.text("No items, sorry!")])]
    _ -> list.map(entries, market_row)
  }
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
