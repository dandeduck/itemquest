import gleam/erlang/process
import gleam/otp/actor.{type Next}
import itemquest/modules/market/submodules/item
import itemquest/utils/logging
import itemquest/web/contexts.{type RequestContext}
import itemquest/web/errors.{type InternalError}

pub type MarketMessage {
  Shutdown
  CreateMarketItem(item_id: Int, ctx: RequestContext)
}

pub fn new() -> Result(process.Subject(MarketMessage), actor.StartError) {
  actor.start([], handle_message)
}

fn handle_message(
  message: MarketMessage,
  failed_messages: List(MarketMessage),
) -> Next(MarketMessage, List(MarketMessage)) {
  case message {
    Shutdown -> actor.Stop(process.Normal)
    CreateMarketItem(item_id, ctx) -> {
      logging.log_info("Incomming CreateMarketItem message", ctx)
      item.create_market_item(item_id, ctx)
      |> handle_result(ctx, message, failed_messages)
    }
  }
}

fn handle_result(
  result: Result(t, InternalError(e)),
  ctx: RequestContext,
  message: MarketMessage,
  failed_messages: List(MarketMessage),
) -> actor.Next(MarketMessage, List(MarketMessage)) {
  case result {
    Ok(_) -> actor.continue(failed_messages)
    Error(error) -> {
      logging.log_error("Handling failed: " <> error.message, ctx)
      actor.continue([message, ..failed_messages])
      // TODO: can omit messages from the list in case they failed in a certain way
    }
  }
}
