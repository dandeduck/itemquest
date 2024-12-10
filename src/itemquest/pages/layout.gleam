import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html

pub fn layout(page: Element(t)) -> Element(t) {
  html.html([], [
    html.head([], [
      html.title([], "itemquest"),
      html.meta([
        attribute.name("viewport"),
        attribute.attribute("content", "width=device-width, initial-scale=1"),
      ]),
      tailwind(),
      ..turbo_scripts()
    ]),
    html.body([], [page]),
  ])
}

fn tailwind() -> Element(t) {
    html.link([attribute.rel("stylesheet"), attribute.type_("text/css"), attribute.href("generated/css/app.css")])
}

fn turbo_scripts() -> List(Element(t)) {
  [
    html.script(
      [attribute.type_("importmap")],
      " {
            \"imports\": {
                \"turbo\": \"https://unpkg.com/@hotwired/turbo@8.0.10/dist/turbo.es2017-esm.js\",
            }
        }",
    ),
    html.script([attribute.type_("module")], "import * as turbo from 'turbo'"),
  ]
}
