import itemquest/utils/ui
import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html

pub fn page() -> Element(t) {
  html.section([], [
    html.img([
      attribute.src("/public/icons/logo.svg"),
      attribute.class("h-9 mb-5"),
    ]),
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
          html.div([], [
            html.label(
              [attribute.class("text-sm mb-2 block"), attribute.for("email")],
              [html.text("Email")],
            ),
            html.div([attribute.class("relative")], [
              html.input([
                attribute.id("email"),
                attribute.type_("email"),
                attribute.name("email"),
                attribute.required(True),
                attribute.placeholder("e.g. item@quest.gg"),
                attribute.class("pe-3 ps-9 py-1.5 rounded border-font-color"),
                attribute.class(
                  "w-full bg-[transparent] placeholder:opacity-[0.6]",
                ),
              ]),
              html.img([
                attribute.src("/public/icons/email.svg"),
                attribute.class(
                  "w-4 absolute top-2 left-3 translate-y-1/2 dark:invert",
                ),
              ]),
            ]),
          ]),
          html.button(
            [
              attribute.type_("submit"),
              attribute.class("bg-primary font-bold rounded px-3 py-2"),
            ],
            [html.text("Join the waitlist")],
          ),
        ],
      ),
    ]),
    html.div(
      [
        attribute.class(
          "flex flex-col md:flex-row gap-10 md:justify-between text-xl",
        ),
        attribute.class("[&>*>h2]:text-primary [&>*>h2]:mb-5 [&>*>h2]:text-3xl"),
        attribute.class("[&>*>h2]:font-bold [&>*>div]:space-y-3"),
      ],
      [
        html.article([], [
          html.h2([], [html.text("Games")]),
          html.div([], [
            html.div([attribute.class("flex gap-2")], [
              html.img([
                attribute.src("/public/icons/storefront.svg"),
                attribute.class("w-5 h-5 mt-[3px]"),
              ]),
              html.p([], [
                html.text("Item system and a marketplace free of charge"),
              ]),
            ]),
            html.div([attribute.class("flex gap-2")], [
              html.img([
                attribute.src("/public/icons/coin.svg"),
                attribute.class("w-5 h-5 mt-[3px]"),
              ]),
              html.p([], [html.text("Earn comission on every transaction")]),
            ]),
            html.div([attribute.class("flex gap-2")], [
              html.img([
                attribute.src("/public/icons/chart-line.svg"),
                attribute.class("w-5 h-5 mt-[3px]"),
              ]),
              html.p([], [
                html.text("View analytics and monitor statistics on your items"),
              ]),
            ]),
          ]),
        ]),
        html.article([], [
          html.h2([], [html.text("Players")]),
          html.div([], [
            html.div([attribute.class("flex gap-2")], [
              html.img([
                attribute.src("/public/icons/cash.svg"),
                attribute.class("w-5 h-5 mt-[3px]"),
              ]),
              html.p([], [
                html.text("Withdraw real-world money from items you sold"),
              ]),
            ]),
            html.div([attribute.class("flex gap-2")], [
              html.img([
                attribute.src("/public/icons/magic.svg"),
                attribute.class("w-5 h-5 mt-[3px]"),
              ]),
              html.p([], [
                html.text("Trade freely between all games on the platform"),
              ]),
            ]),
          ]),
        ]),
      ],
    ),
  ])
}
