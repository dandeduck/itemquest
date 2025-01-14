import lustre/attribute.{type Attribute}
import lustre/element.{type Element}
import lustre/element/html
import gleam/option.{type Option}

pub fn eager_loading_frame(
  attr: List(Attribute(t)),
  load_from src: String,
) -> Element(t) {
  // todo: Add spinner inside of the frame
  turbo_frame([attribute.src(src), ..attr], [])
}

pub fn turbo_frame(
  attrs: List(Attribute(t)),
  children: List(Element(t)),
) -> Element(t) {
  element.element("turbo-frame", attrs, children)
}

pub type TurboStreamAction {
  StreamAppend
  StreamPrepend
  StreamUpdate
  StreamReplace
  StreamRemove
  StreamBefore
  StreamAfter
  StreamRefresh
}

pub fn turbo_stream(
  action: TurboStreamAction,
  target: String,
  elements: List(Element(t)),
) -> Element(t) {
  let action = case action {
    StreamAppend -> "append"
    StreamPrepend -> "prepend"
    StreamUpdate -> "update"
    StreamReplace -> "replace"
    StreamRemove -> "remove"
    StreamBefore -> "before"
    StreamAfter -> "after"
    StreamRefresh -> "refresh"
  }
  element.element(
    "turbo-stream",
    [attribute.action(action), attribute.target(target)],
    [html.template([], elements)],
  )
}

pub fn turbo_stream_source() -> Element(t) {
  element.element("turbo-stream-source", [], [])
}

pub fn icon(name: String, class: Option(String)) -> Element(t) {
  html.span([attribute.class("material-symbols-outlined flex items-center justify-center " <> option.unwrap(class, ""))], [
    html.text(name),
  ])
}
