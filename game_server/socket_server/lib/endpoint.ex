defmodule SocketServer.Endpoint do
  use Phoenix.Endpoint, otp_app: :socket_server
  plug CORSPlug, origin: "*"
  socket "/socket", SocketServer.Socket, websocket: true, longpoll: false
  plug SocketServer.GameConfig

  def init(_key, config) do
    if config[:load_from_system_env] do
      port = 80
      {:ok, Keyword.put(config, :http, [:inet6, port: port])}
    else
      {:ok, config}
    end
  end
end
