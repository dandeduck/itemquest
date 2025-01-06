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
    html.body([attribute.class("text-black bg-white")], [header(), main(page)]),
  ])
}

fn tailwind() -> Element(t) {
  html.link([
    attribute.rel("stylesheet"),
    attribute.type_("text/css"),
    attribute.href("/generated/css/app.css"),
  ])
}

fn turbo_scripts() -> List(Element(t)) {
  [
    html.script(
      [attribute.type_("importmap")],
      " {
            \"imports\": {
                \"turbo\": \"https://unpkg.com/@hotwired/turbo@8.0.10/dist/turbo.es2017-esm.js\"
            }
        }",
    ),
    html.script([attribute.type_("module")], "import * as turbo from 'turbo'"),
  ]
}

fn main(page: Element(t)) -> Element(t) {
  html.main([attribute.class("w-3/4 mx-auto")], [page])
}

fn header() -> Element(t) {
  html.header([attribute.class("bg-gray mb-20")], [
    html.div(
      [attribute.class("flex justify-between h-20 w-3/4 items-center mx-auto")],
      [
        html.h1([attribute.class("text-2xl")], [html.text("logo")]),
        html.div([attribute.class("flex gap-10")], [
          html.h1([attribute.class("text-2xl")], [html.text("100$")]),
          html.h1([attribute.class("text-2xl")], [html.text("profile")]),
        ]),
      ],
    ),
  ])
}
