import itemquest/utils/ui
import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html

pub fn page() -> Element(t) {
  html.section([attribute.class("text-3xl")], [
    html.h1([attribute.class("flex items-baseline gap-5 mb-20")], [
      html.span([attribute.class("text-4xl")], [html.text("Itemquest")]),
      html.span([], [
        html.text("a cross platform marketplace for in-game items"),
      ]),
    ]),
    html.article([attribute.class("mb-10")], [
      html.h2([attribute.class("text-red")], [html.text("Games")]),
      html.div([attribute.class("pl-20")], [
        html.p([], [html.text("Items system and a marketplace free of charge")]),
        html.p([], [html.text("Earn comission on every transaction")]),
        html.p([], [
          html.text("View analytics and monitor statistics on your items"),
        ]),
      ]),
    ]),
    html.article([attribute.class("mb-10")], [
      html.h2([attribute.class("text-red")], [html.text("Players")]),
      html.div([attribute.class("pl-20")], [
        html.p([], [html.text("Withdraw real-world money from items you sold")]),
        html.p([], [html.text("Trade freely between all games on the platform")]),
      ]),
    ]),
    html.h2([], [
      html.text("Be one of the first games to join! Enter the waitlist"),
    ]),
    ui.turbo_frame([attribute.id("waitlist_form")], [
      html.form(
        [
          attribute.enctype("multipart/form-data"),
          attribute.action("/waitlist"),
          attribute.method("post"),
          attribute.class("flex"),
        ],
        [
          html.input([
            attribute.type_("email"),
            attribute.name("email"),
            attribute.required(True),
            attribute.placeholder("contact@itemquest.gg"),
          ]),
          html.button([attribute.type_("submit")], [html.text("Submit")]),
        ],
      ),
    ]),
  ])
}
