import gleam/float
import gleam/int
import gleam/list
import gleam/option.{type Option}
import itemquest/modules/market/internal.{
  type MarketItemsFilter, type MarketSortBy, type SortDirection,
}
import itemquest/modules/market/sql.{type SelectMarketItemsRow}
import itemquest/utils/ui
import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html

const market_rows_container = "market_rows_container"

pub fn html(filter: MarketItemsFilter) -> Element(t) {
  html.div([], [
    html.table([attribute.class("w-full")], [
      html.tbody([attribute.id(market_rows_container)], [
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
              sorting_header(internal.SortByQuantity, filter),
            ]),
            html.th([attribute.class("w-0")], [
              sorting_header(internal.SortByPopularity, filter),
            ]),
            html.th([attribute.class("w-20")], [
              sorting_header(internal.SortByPrice, filter),
            ]),
          ],
        ),
        // todo: fix me!
        html.script(
          [attribute.type_("module")],
          "
                import utils from '@itemquest/utils'

                const url = new URL(window.location.href)
                url.pathname += '/items'
                utils.fetchStream(url.toString())
                ",
        ),
      ]),
    ]),
    load_more(filter)
  ])
}

pub fn market_items_stream(
  filter: MarketItemsFilter,
  items: List(SelectMarketItemsRow),
) -> Element(t) {
  items
  |> list.map(market_row(_, filter.market_id))
  |> ui.turbo_stream(ui.StreamAppend, market_rows_container, _)
}

fn market_row(item: SelectMarketItemsRow, market_id: Int) -> Element(t) {
  html.tr(
    [
      attribute.class(
        "[&>*]:text-start [&>:not(:last-child)]:pr-10 [&>*]:p-2 [&>*]:border-y-8 [&>*]:border-white bg-gray",
      ),
      ui.turbo_visit_attribute(
        int.to_string(market_id) <> "/items/" <> int.to_string(item.item_id),
      ),
    ],
    [
      html.td([], [
        html.img([attribute.src(item.image_url), attribute.class("h-10")]),
      ]),
      html.td([], [html.text(item.name)]),
      html.td([], [html.text(int.to_string(item.quantity))]),
      html.td([], [html.text(int.to_string(item.popularity))]),
      html.td([], [
        html.text(case item.price {
          option.Some(price) -> float.to_string(int.to_float(price) /. 100.0)
          _ -> "-"
        }),
      ]),
    ],
  )
}

fn load_more(filter: MarketItemsFilter) -> Element(t) {
  let filter =
    internal.MarketItemsFilter(..filter, offset: filter.offset + filter.limit)
  html.a(
    [
      attribute.attribute("data-turbo-stream", "true"),
      attribute.href(
        int.to_string(filter.market_id)
        <> "/items"
        <> internal.get_market_query(filter),
      ),
    ],
    [html.text("LOAD MORE")],
  )
}

fn sorting_header(
  sort_by: MarketSortBy,
  filter: MarketItemsFilter,
) -> Element(a) {
  html.h2([attribute.class("flex items-center gap-1")], [
    html.text(internal.sort_by_to_string(sort_by)),
    header_sorting(sort_by, filter, case sort_by == filter.sort_by {
      True -> option.Some(filter.sort_direction)
      _ -> option.None
    }),
  ])
}

fn header_sorting(
  sort_by: MarketSortBy,
  filter: MarketItemsFilter,
  selected_direction: Option(SortDirection),
) -> Element(a) {
  html.div([attribute.class("flex gap-1 flex-col")], [
    html.a(
      [
        attribute.href(internal.get_market_query(
          internal.MarketItemsFilter(
            ..filter,
            sort_by:,
            offset: 0,
            sort_direction: internal.AscendingSort,
          ),
        )),
      ],
      [
        ui.icon(
          "arrow_drop_down",
          option.Some(
            "rotate-180 w-4 h-4 "
            <> case selected_direction {
              option.Some(internal.AscendingSort) -> "opacity-100"
              _ -> "opacity-50"
            },
          ),
        ),
      ],
    ),
    html.a(
      [
        attribute.href(internal.get_market_query(
          internal.MarketItemsFilter(
            ..filter,
            sort_by:,
            offset: 0,
            sort_direction: internal.DescendingSort,
          ),
        )),
      ],
      [
        ui.icon(
          "arrow_drop_down",
          option.Some(
            "w-4 h-4 "
            <> case selected_direction {
              option.Some(internal.DescendingSort) -> "opacity-100"
              _ -> "opacity-50"
            },
          ),
        ),
      ],
    ),
  ])
}
