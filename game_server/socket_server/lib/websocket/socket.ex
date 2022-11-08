defmodule SocketServer.Socket do
  use Phoenix.Socket, log: false

  channel "updates", SocketServer.Updates
  channel "input",   SocketServer.Input
  channel "sync",    SocketServer.Sync

  def connect(_params, socket) do
    {:ok, socket}
  end
  def id(_socket), do: nil
end
