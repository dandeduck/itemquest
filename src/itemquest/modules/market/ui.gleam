import gleam/float
import gleam/int
import gleam/list
import gleam/option
import gleam/uri.{type Uri}
import itemquest/modules/market/sql.{
  type SelectMarketEntriesRow, type SelectMarketRow,
}
import itemquest/utils/ui
import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html

const market_rows_container_id = "market_rows_container"

pub fn page(market: SelectMarketRow, market_entries_uri: Uri) -> Element(t) {
  html.section([], [
    html.header([], [
      html.h1([attribute.class("color-black text-3xl mb-20")], [
        html.text(market.name),
      ]),
    ]),
    html.table([attribute.class("w-full")], [
      html.tbody([attribute.id(market_rows_container_id)], [
        html.tr(
          [
            attribute.class(
              "[&>*]:text-start [&>:not(:last-child)]:pr-10 [&>*]:border-b-8 [&>*]:border-white",
            ),
          ],
          [
            html.th([attribute.class("w-0")], [
              html.h2([], [html.text("image")]),
            ]),
            html.th([], [html.h2([], [html.text("item name")])]),
            html.th([attribute.class("w-0")], [
              html.h2([attribute.class("flex items-center")], [
                html.text("quantity"),
                html.div([], [
                  html.a(
                    [attribute.href("?sort_by=quantity&sort_direction=asc")],
                    [ui.icon("arrow_drop_down", option.Some("rotate-180"))],
                  ),
                  html.a(
                    [attribute.href("?sort_by=quantity&sort_direction=desc")],
                    [ui.icon("arrow_drop_down", option.None)],
                  ),
                ]),
              ]),
            ]),
            html.th([attribute.class("w-0")], [
              html.h2([], [html.text("popularity")]),
            ]),
            html.th([attribute.class("w-10")], [
              html.h2([attribute.class("flex items-center")], [
                html.text("price"),
                html.div([], [
                  html.a(
                    [attribute.href("?sort_by=price&sort_direction=asc")],
                    [ui.icon("arrow_drop_down", option.Some("rotate-180"))],
                  ),
                  html.a(
                    [attribute.href("?sort_by=price&sort_direction=desc")],
                    [ui.icon("arrow_drop_down", option.None)],
                  ),
                ]),
              ]),
            ]),
          ],
        ),
        ui.eager_loading_frame(
          [attribute.attribute("data-turbo-stream", "true")],
          load_from: uri.to_string(market_entries_uri),
        ),
      ]),
    ]),
  ])
}

pub fn market_rows(entries: List(SelectMarketEntriesRow)) -> Element(t) {
  case entries {
    // todo: fix me!
    [] -> [html.h2([], [html.text("No items, sorry!")])]
    _ -> list.map(entries, market_row)
  }
  |> ui.turbo_stream(ui.StreamAppend, market_rows_container_id, _)
}

fn market_row(entry: SelectMarketEntriesRow) -> Element(t) {
  html.tr(
    [
      attribute.class(
        "[&>*]:text-start [&>:not(:last-child)]:pr-10 [&>*]:p-2 [&>*]:border-y-8 [&>*]:border-white bg-gray",
      ),
    ],
    [
      html.th([], [
        case entry.image_url {
          option.Some(image_url) ->
            html.img([attribute.src(image_url), attribute.class("h-10")])
          _ -> html.text("")
        },
      ]),
      html.th([], [html.text(entry.name)]),
      html.th([], [html.text(int.to_string(entry.quantity))]),
      html.th([], [html.text("0")]),
      html.th([], [
        html.text(case entry.price {
          option.Some(price) -> float.to_string(int.to_float(price) /. 100.0)
          _ -> "-"
        }),
      ]),
    ],
  )
}
