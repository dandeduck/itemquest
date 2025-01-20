import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html

pub fn page() -> Element(t) {
  html.h1([attribute.class("color-black text-lg")], [
    html.text("Homepage"),
    html.a([attribute.href("/users")], [html.text("click me")]),
  ])
}
