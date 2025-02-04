import itemquest/modules/market/internal.{type MarketItemsFilter}
import itemquest/modules/market/sql.{type SelectMarketRow}
import itemquest/modules/market/ui/market_page/header
import itemquest/modules/market/ui/market_page/table
import lustre/element.{type Element}
import lustre/element/html

pub fn page(market: SelectMarketRow, filter: MarketItemsFilter) -> Element(t) {
  html.section([], [header.html(market, filter), table.frame(filter)])
}

pub const search_results_stream = header.search_results_stream

pub const market_items_table = table.html

pub const market_rows_stream = table.market_items_stream
