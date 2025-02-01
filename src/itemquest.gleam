import dot_env
import dot_env/env
import gleam/erlang/process
import gleam/result
import itemquest/router
import itemquest/web/contexts
import mist
import pog.{type Connection}
import wisp
import wisp/wisp_mist

pub fn main() {
  wisp.configure_logger()

  dot_env.new()
  |> dot_env.set_path(".env")
  |> dot_env.set_debug(False)
  |> dot_env.load()

  let assert Ok(secret_key_base) = env.get_string("SECRET_KEY_BASE")
  let assert Ok(db_url) = env.get_string("DATABASE_URL")

  let assert Ok(db) = connect_db(db_url)

  let ctx = contexts.ServerContext(priv_directory(), db)

  let assert Ok(_) =
    wisp_mist.handler(router.handle_request(_, ctx), secret_key_base)
    |> mist.new
    |> mist.port(8080)
    |> mist.bind("0.0.0.0")
    |> mist.start_http

  process.sleep_forever()
}

fn priv_directory() {
  let assert Ok(priv_directory) = wisp.priv_directory("itemquest")
  priv_directory
}

fn connect_db(url: String) -> Result(Connection, Nil) {
  use config <- result.try(pog.url_config(url))

  config
  |> pog.ip_version(pog.Ipv6)
  |> pog.connect
  |> Ok
}
