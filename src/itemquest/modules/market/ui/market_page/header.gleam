import gleam/list
import gleam/result
import itemquest/modules/market/internal.{type MarketSortBy, type SortDirection}
import itemquest/modules/market/sql.{type SelectMarketRow}
import itemquest/utils/ui
import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html

const search_results_container_id = "search_results_container"

pub fn html(
  market: SelectMarketRow,
  sort_by: MarketSortBy,
  sort_direction: SortDirection,
  search: Result(String, Nil),
) -> Element(t) {
  html.header([attribute.class("mb-20")], [
    html.h1([attribute.class("color-black text-3xl mb-10")], [
      html.text(market.name),
    ]),
    search_bar(sort_by, sort_direction, search),
  ])
}

pub fn search_results_stream(names: List(String)) -> Element(t) {
  names
  |> list.map(search_result)
  |> ui.turbo_stream(ui.StreamUpdate, search_results_container_id, _)
}

fn search_result(name: String) -> Element(t) {
  html.div([], [html.text(name)])
}

fn search_bar(
  sort_by: MarketSortBy,
  sort_direction: SortDirection,
  search: Result(String, Nil),
) -> Element(a) {
  html.search([attribute.class("relative")], [
    search_script(),
    html.form([], [
      html.input([
        attribute.type_("hidden"),
        attribute.name("sort_by"),
        sort_by |> internal.sort_by_to_string |> attribute.value,
      ]),
      html.input([
        attribute.type_("hidden"),
        attribute.name("sort_direction"),
        sort_direction
          |> internal.sort_direction_to_string
          |> attribute.value,
      ]),
      html.input([
        attribute.id("search_input"),
        attribute.name("search"),
        attribute.placeholder("search"),
        attribute.autocomplete("off"),
        attribute.type_("search"),
        attribute.value(result.unwrap(search, "")),
        attribute.class("w-full"),
      ]),
    ]),
    html.div(
      [
        attribute.id(search_results_container_id),
        attribute.class("absolute bg-gray w-full"),
      ],
      [],
    ),
  ])
}

fn search_script() -> Element(a) {
  html.script(
    [attribute.type_("module")],
    "
        import utils from '@itemquest/utils';

        utils.addAutocompleteSuggestions('search_input', (value) => {
            const searchUrl = new URL(window.location.href);
            searchUrl.pathname += '/items/search';
            searchUrl.search = '';
            searchUrl.searchParams.append('search', value);

            return searchUrl.toString();
        });
    ",
  )
}
