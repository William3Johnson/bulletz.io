defmodule SocketServer.Sync do
  use Phoenix.Channel, log_join: false, log_handle_in: false

  def join("sync", _message, socket) do
    { :ok, socket }
  end

  def handle_in("time", _options, socket) do
    {:reply, {:ok, %{time: :erlang.system_time(:milli_seconds)}}, socket}
  end

  def broadcast_sync() do
    SocketServer.Endpoint.broadcast("sync", "time", %{time: :erlang.system_time(:milli_seconds)})
  end

end
