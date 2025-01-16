import gleam/uri.{type Uri}
import itemquest/modules/market/internal.{type MarketSortBy, type SortDirection}
import itemquest/modules/market/sql.{type SelectMarketRow}
import itemquest/modules/market/ui/market_page/header
import itemquest/modules/market/ui/market_page/table
import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html

pub fn page(
  market: SelectMarketRow,
  market_items_uri: Uri,
  sort_by: MarketSortBy,
  sort_direction: SortDirection,
  search: Result(String, Nil),
) -> Element(t) {
  html.section([], [
    html.script(
      [attribute.type_("module"), attribute.src("/public/js/market/page.js")],
      "",
    ),
    header.html(market, sort_by, sort_direction, search),
    table.html(market_items_uri, sort_by, sort_direction, search),
  ])
}

pub const search_results_stream = header.search_results_stream

pub const market_rows_stream = table.market_items_stream
