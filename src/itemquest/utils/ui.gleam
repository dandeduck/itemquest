import lustre/attribute.{type Attribute}
import lustre/element.{type Element}

pub fn turbo_frame(
  id: String,
  attrs: List(Attribute(t)),
  children: List(Element(t)),
) -> Element(t) {
  element.element("turbo-frame", [attribute.id(id), ..attrs], children)
}
