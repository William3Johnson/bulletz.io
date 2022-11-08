defmodule SocketServer.Syncer do
  use GenServer
  def init(args) do
    schedule_tick()
    {:ok, args}
   end

  def start_link() do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def handle_info(:tick, _) do
    SocketServer.Sync.broadcast_sync()
    schedule_tick()
    {:noreply, :ok}
  end

  defp schedule_tick() do
    Process.send_after(self(), :tick, 500)
  end
end
