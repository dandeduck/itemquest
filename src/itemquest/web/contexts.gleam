import pog.{type Connection}
import radish/client.{type Client}

pub type Secrets {
  Secrets(jwt: String)
}

pub type ServerContext {
  ServerContext(
    priv_directory: String,
    db: Connection,
    cache: Client,
    secrets: Secrets,
  )
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
    cache: Client,
    secrets: Secrets,
  )
}
