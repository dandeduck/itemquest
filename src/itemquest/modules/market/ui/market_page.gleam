import gleam/uri.{type Uri}
import itemquest/modules/market/internal.{
  type MarketEntriesSortBy, type SortDirection,
}
import itemquest/modules/market/sql.{
  type SelectMarketEntriesRow, type SelectMarketRow,
}
import itemquest/modules/market/ui/market_page/header
import itemquest/modules/market/ui/market_page/script
import itemquest/modules/market/ui/market_page/table
import lustre/element.{type Element}
import lustre/element/html

pub fn page(
  market: SelectMarketRow,
  market_entries_uri: Uri,
  sort_by: MarketEntriesSortBy,
  sort_direction: SortDirection,
  search: Result(String, Nil),
) -> Element(t) {
  html.section([], [
    script.html(),
    header.html(market, sort_by, sort_direction, search),
    table.html(market_entries_uri, sort_by, sort_direction, search),
  ])
}

pub fn search_results_stream(names: List(String)) -> Element(t) {
  header.search_results_stream(names)
}

pub fn market_rows_stream(entries: List(SelectMarketEntriesRow)) -> Element(t) {
  table.market_rows_stream(entries)
}
