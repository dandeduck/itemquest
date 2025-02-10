import pog.{type Connection}

pub type Secrets {
  Secrets(jwt: String)
}

pub type ServerContext {
  ServerContext(priv_directory: String, db: Connection, secrets: Secrets)
}

pub type Authentication {
  Unauthenticated
  PlatformUser(user_id: String)
  ApiClient(client_id: String)
}

pub type RequestContext {
  RequestContext(
    db: Connection,
    request_id: String,
    auth: Authentication,
    secrets: Secrets,
  )
}
