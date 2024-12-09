import lustre/element.{type Element, text}
import lustre/element/html.{h1}

pub fn page() -> Element(t) {
  h1([], [text("Homepage")])
}
