defmodule SocketServer.GameConfig do
  use Plug.Router

  plug :match
  plug(:dispatch)

  get "/config" do
    conn |>
      put_resp_content_type("application/json") |>
      send_resp(200, bundle_config())
  end

  def bundle_config() do
    player_config = GameConfig.get(:player)
    bullet_config = GameConfig.get(:bullet)
    world_config  = GameConfig.get(:world)
    frost_config  = GameConfig.get(:frost)
    ghost_config  = GameConfig.get(:ghost)

    %{
      player: player_config,
      frost: frost_config,
      ghost: ghost_config,
      bullet: bullet_config,
      world:  world_config
    } |>
    Poison.encode!()
  end
end
