import dot_env
import dot_env/env
import gleam/erlang/process
import itemquest/router
import itemquest/contexts.{ServerContext}
import mist
import wisp
import wisp/wisp_mist

pub fn main() {
  wisp.configure_logger()

  dot_env.new()
  |> dot_env.set_path(".env")
  |> dot_env.set_debug(False)
  |> dot_env.load()

  let assert Ok(secret_key_base) = env.get_string("SECRET_KEY_BASE")

  let ctx = ServerContext(generated_directory: generated_directory())

  let assert Ok(_) =
    wisp_mist.handler(router.handle_request(_, ctx), secret_key_base)
    |> mist.new
    |> mist.port(8000)
    |> mist.start_http

  process.sleep_forever()
}

fn generated_directory() {
  let assert Ok(priv_directory) = wisp.priv_directory("itemquest")
  priv_directory <> "/static"
}
