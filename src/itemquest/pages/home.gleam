import lustre/element/html
import lustre/attribute
import lustre/element.{type Element}

pub fn page() -> Element(t) {
  html.h1([], [html.text("Homepage"), html.a([attribute.href("/users")], [html.text("click me")])])
}
