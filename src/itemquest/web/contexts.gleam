import pog.{type Connection}

pub type ServerContext {
  ServerContext(priv_directory: String, db: Connection)
}

pub type RequestContext {
  Unauthorized(db: Connection, request_id: String)
  Authorized(db: Connection, request_id: String, user_id: String)
}
