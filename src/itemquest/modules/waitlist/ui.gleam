import itemquest/utils/ui
import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html

pub fn page() -> Element(t) {
  html.section([], [
    html.h1([attribute.class("text-4xl mb-5")], [html.text("itemQuest")]),
    html.h1([attribute.class("text-3xl")], [
      html.text("A cross platform marketplace"),
      html.br([attribute.class("md:hidden")]),
      html.text("for in-game items"),
    ]),
    ui.turbo_frame([attribute.id("waitlist_form")], [
      html.form(
        [
          attribute.enctype("multipart/form-data"),
          attribute.action("/waitlist"),
          attribute.method("post"),
          attribute.class("flex flex-col gap-3 my-20"),
        ],
        [
          html.h2([attribute.class("text-xl")], [
            html.text("Be one of the first games to join!"),
          ]),
          html.input([
            attribute.type_("email"),
            attribute.name("email"),
            attribute.required(True),
            attribute.placeholder("e.g. item@quest.gg"),
          ]),
          html.button(
            [attribute.type_("submit"), attribute.class("bg-primary font-bold")],
            [html.text("Join the waitlist")],
          ),
        ],
      ),
    ]),
    html.div(
      [
        attribute.class(
          "flex flex-col md:flex-row gap-10 md:justify-between text-xl [&>*>h2]:text-primary [&>*>h2]:mb-5 [&>*>h2]:text-3xl [&>*>h2]:font-bold [&>*>div]:space-y-3",
        ),
      ],
      [
        html.article([], [
          html.h2([], [html.text("Games")]),
          html.div([], [
            html.p([], [
              html.text("Items system and a marketplace free of charge"),
            ]),
            html.p([], [html.text("Earn comission on every transaction")]),
            html.p([], [
              html.text("View analytics and monitor statistics on your items"),
            ]),
          ]),
        ]),
        html.article([], [
          html.h2([], [html.text("Players")]),
          html.div([], [
            html.p([], [
              html.text("Withdraw real-world money from items you sold"),
            ]),
            html.p([], [
              html.text("Trade freely between all games on the platform"),
            ]),
          ]),
        ]),
      ],
    ),
  ])
}
