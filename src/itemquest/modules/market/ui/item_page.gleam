import itemquest/modules/market/sql.{type SelectMarketItemRow}
import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html

pub fn page(item: SelectMarketItemRow) -> Element(a) {
  html.section([], [
    html.header([attribute.class("mb-20")], [
      html.h1([attribute.class("color-black text-3xl mb-10")], [
        html.text(item.name),
      ]),
    ]),
  ])
}
