defmodule Scoreboard.Server do
  use GenServer
  alias Scoreboard.Impl, as: Impl

  def init(args) do
    schedule_update()
    schedule_broadcast()
   {:ok, args}
  end

  def start_link(world, broadcast_scoreboard) do
    GenServer.start_link(__MODULE__, %{world: world, broadcast_scoreboard: broadcast_scoreboard, scoreboard: []}, name: __MODULE__)
  end

  def handle_info(:update, state) do
    schedule_update()
    {:noreply, Impl.update_scoreboard(state)}
  end
  def handle_info(:broadcast, state = %{broadcast_scoreboard: broadcast_scoreboard, scoreboard: scoreboard}) do
    broadcast_scoreboard.(scoreboard)
    schedule_broadcast()
    {:noreply, state}
  end

  def handle_call({:scoreboard}, _from, state) do
    {:reply, state, state}
  end


  defp schedule_update() do
    Process.send_after(self(), :update, 300)
  end
  defp schedule_broadcast() do
    Process.send_after(self(), :broadcast, 300)
  end
end
