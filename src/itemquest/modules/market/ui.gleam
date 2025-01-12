import gleam/float
import gleam/int
import gleam/list
import gleam/option
import gleam/result
import gleam/uri.{type Uri}
import itemquest/modules/market/internal.{
  type MarketEntriesSortBy, type SortDirection,
}
import itemquest/modules/market/sql.{
  type SelectMarketEntriesRow, type SelectMarketRow,
}
import itemquest/utils/ui
import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html

const market_rows_container_id = "market_rows_container"

pub fn page(
  market: SelectMarketRow,
  market_entries_uri: Uri,
  sort_by: MarketEntriesSortBy,
  sort_direction: SortDirection,
  search: Result(String, Nil),
) -> Element(t) {
  html.section([], [
    html.script(
      [attribute.type_("module")],
      "
        const limit = 25
        let offset = 0
        let fetching = false

        const listener = window.addEventListener('scroll', () => {
            const entriesUrl = new URL(window.location.href)
            entriesUrl.pathname += '/entries'

            window.requestAnimationFrame(async () => {
                if (!fetching && window.scrollY + window.innerHeight >= document.body.offsetHeight - 500) {
                    fetching = true
                    offset += limit
                    entriesUrl.searchParams.set('offset', offset)

                    const success = await fetchStream(entriesUrl.toString())
                    if (success) {
                        fetching = false
                    }
                }
            }, 0)
        })

        async function fetchStream(url) {
            const response = await fetch(url, {
                method: 'get', 
                headers: {
                    'Accept': 'text/vnd.turbo-stream.html',
                }
            })

            if (response.status !== 200) {
                return false
            }

            const html = await response.text();
            Turbo.renderStreamMessage(html)
            return true
        }
    ",
    ),
    html.header([attribute.class("mb-20")], [
      html.h1([attribute.class("color-black text-3xl mb-10")], [
        html.text(market.name),
      ]),
      html.search([], [
        html.form([], [
          html.input([
            attribute.type_("hidden"),
            attribute.name("sort_by"),
            sort_by |> internal.sort_by_to_string |> attribute.value,
          ]),
          html.input([
            attribute.name("sort_direction"),
            attribute.type_("hidden"),
            sort_direction
              |> internal.sort_direction_to_string
              |> attribute.value,
          ]),
          html.input([
            attribute.name("search"),
            attribute.placeholder("search"),
            attribute.type_("text"),
            attribute.value(result.unwrap(search, "")),
            attribute.class("w-full"),
          ]),
        ]),
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
                header_sorting(internal.SortByQuantity, search),
              ]),
            ]),
            html.th([attribute.class("w-0")], [
              html.h2([attribute.class("flex items-center")], [
                html.text("popularity"),
                header_sorting(internal.SortByPopularity, search),
              ]),
            ]),
            html.th([attribute.class("w-20")], [
              html.h2([attribute.class("flex items-center")], [
                html.text("price"),
                header_sorting(internal.SortByPrice, search),
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
  entries
  |> list.map(market_row)
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
        html.img([attribute.src(entry.image_url), attribute.class("h-10")]),
      ]),
      html.th([], [html.text(entry.name)]),
      html.th([], [html.text(int.to_string(entry.quantity))]),
      html.th([], [html.text(int.to_string(entry.popularity))]),
      html.th([], [
        html.text(case entry.price {
          option.Some(price) -> float.to_string(int.to_float(price) /. 100.0)
          _ -> "-"
        }),
      ]),
    ],
  )
}

fn header_sorting(
  sort_by: MarketEntriesSortBy,
  search: Result(String, Nil),
) -> Element(a) {
  html.div([], [
    html.a(
      [
        attribute.href(internal.get_market_query(
          sort_by,
          internal.AscendingSort,
          search,
        )),
      ],
      [ui.icon("arrow_drop_down", option.Some("rotate-180"))],
    ),
    html.a(
      [
        attribute.href(internal.get_market_query(
          sort_by,
          internal.DescendingSort,
          search,
        )),
      ],
      [ui.icon("arrow_drop_down", option.None)],
    ),
  ])
}
