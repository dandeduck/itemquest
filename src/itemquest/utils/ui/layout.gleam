import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html

pub fn layout(page: Element(t)) -> Element(t) {
  html.html([attribute.class("bg-bg-color text-font-color font-sans")], [
    html.head([], [
      html.title([], "itemquest"),
      html.meta([
        attribute.name("viewport"),
        attribute.attribute("content", "width=device-width, initial-scale=1"),
      ]),
      html.meta([
        attribute.name("view-transition"),
        attribute.content("same-origin"),
      ]),
      icons(),
      tailwind(),
      charts_script(),
      import_map_script(),
      turbo_script(),
      html.script(
        [attribute.type_("module"), attribute.src("/public/js/augments.js")],
        "",
      ),
    ]),
    html.body([], [header(), main(page)]),
  ])
}

fn icons() -> Element(t) {
  html.link([
    attribute.rel("stylesheet"),
    attribute.href(
      "https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@24,400,0,0&icon_names=arrow_drop_down&display=block",
    ),
  ])
}

fn tailwind() -> Element(t) {
  html.link([
    attribute.rel("stylesheet"),
    attribute.type_("text/css"),
    attribute.href("/generated/css/tailwind.css"),
  ])
}

fn charts_script() -> Element(t) {
  html.script(
    [
      attribute.src(
        "https://cdn.jsdelivr.net/npm/echarts@5.6.0/dist/echarts.min.js",
      ),
    ],
    "",
  )
}

fn turbo_script() -> Element(t) {
  html.script([attribute.type_("module")], "import * as turbo from 'turbo'")
}

// todo: Add reload on changes and version identifier
fn import_map_script() -> Element(t) {
  html.script(
    [attribute.type_("importmap")],
    " {
        \"imports\": {
            \"turbo\": \"https://unpkg.com/@hotwired/turbo@8.0.10/dist/turbo.es2017-esm.js\",
            \"@itemquest/utils\": \"/public/js/utils.js\",
            \"@itemquest/charts\": \"/public/js/charts.js\"
         }
      }",
  )
}

fn main(page: Element(t)) -> Element(t) {
  html.main([attribute.class("mx-6 sm:mx-10 mb-20")], [page])
}

fn header() -> Element(t) {
  html.header([attribute.class("mb-10")], [
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
