import gleam/erlang/process
import gleam/otp/actor.{type Next}
import itemquest/modules/market/internal
import itemquest/utils/logging
import itemquest/web/contexts.{type RequestContext}
import itemquest/web/errors.{type InternalError}

pub type MarketMessage {
  Shutdown
  CreateMarketEntry(template_id: Int, ctx: RequestContext)
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
    CreateMarketEntry(template_id, ctx) -> {
      logging.log_info("Incomming CreateMarketEntry message", ctx)
      internal.create_market_entry(template_id, ctx)
      |> handle_result(ctx, message, failed_messages)
    }
  }
}

fn handle_result(
  result: Result(t, InternalError),
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
