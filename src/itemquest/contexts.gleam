pub type ServerContext {
  ServerContext(generated_directory: String)
}

pub type RequestContext {
  Unauthorized(request_id: String)
  Authorized(request_id: String, user_id: String)
}

