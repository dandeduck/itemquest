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

pub fn html(filter: MarketItemsFilter, market_id: Int) -> Element(t) {
  html.div([], [
    html.div(
      [
        attribute.class("w-full flex flex-col gap-4 mb-5"),
        attribute.class(
          "[&>*]:grid [&>*]:grid-cols-[50px_1fr_100px_100px_100px]",
        ),
        attribute.class("[&>*]:items-center [&>*]:gap-10"),
        attribute.id(market_rows_container),
      ],
      [
        html.div([], [
          html.h2([], [html.text("image")]),
          html.h2([], [html.text("item name")]),
          sorting_header(internal.SortByQuantity, filter),
          sorting_header(internal.SortByPopularity, filter),
          sorting_header(internal.SortByPrice, filter),
        ]),
      ],
    ),
    load_more(filter),
    ui.eager_loading_frame(
      [ui.turbo_stream_attribute()],
      int.to_string(market_id) <> "/items",
    ),
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
  html.a(
    [
      attribute.href(
        int.to_string(market_id) <> "/items/" <> int.to_string(item.item_id),
      ),
    ],
    [
      html.img([attribute.src(item.image_url), attribute.class("h-10")]),
      html.div([], [html.text(item.name)]),
      html.div([], [html.text(int.to_string(item.quantity))]),
      html.div([], [html.text(int.to_string(item.popularity))]),
      html.div([], [
        html.text(case item.price {
          option.Some(price) -> ui.get_string_price(price)
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
