import itemquest/modules/market/internal.{type MarketItemsFilter}
import itemquest/modules/market/sql.{type SelectMarketRow}
import itemquest/modules/market/ui/header
import itemquest/modules/market/ui/table
import lustre/element.{type Element}
import lustre/element/html

pub fn html(market: SelectMarketRow, filter: MarketItemsFilter) -> Element(t) {
  html.section([], [header.html(market, filter), table.frame(filter)])
}

