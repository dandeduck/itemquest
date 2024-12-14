import wisp
import itemquest/web/contexts.{type RequestContext}

pub fn log_info(message: String, ctx: RequestContext) -> Nil {
  wisp.log_info(ctx.request_id <> message)
}

pub fn log_error(message: String, ctx: RequestContext) -> Nil{
  wisp.log_error(ctx.request_id <> message)
}

pub fn log_warning(message: String, ctx: RequestContext) -> Nil {
  wisp.log_warning(ctx.request_id <> message)
}

