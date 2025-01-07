import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html

pub fn page(market_name: String) -> Element(t) {
  html.section([], [
    html.header([], [
      html.h1([attribute.class("color-black text-3xl mb-20")], [
        html.text(market_name),
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
    ]),
  ])
}

fn market_row() -> Element(t) {
  html.tr([attribute.class("text-start")], [
    html.th([], [html.text("Image")]),
    html.th([], [html.text("Item name")]),
    html.th([], [html.text("Quantity")]),
    html.th([], [html.text("Popularity")]),
    html.th([], [html.text("Price")]),
  ])
}

