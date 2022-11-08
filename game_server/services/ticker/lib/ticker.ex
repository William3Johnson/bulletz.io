defmodule Ticker do
  use GenServer
  alias Ticker.Impl

  def init(args) do
    schedule_tick()
    {:ok, args}
  end

   def start_link(arg) do
     GenServer.start_link(__MODULE__, arg, name: __MODULE__)
   end

   def handle_info(:tick, world) do
     Impl.tick(world)
     schedule_tick()
     {:noreply, world}
   end

   defp schedule_tick() do
     Process.send_after(self(), :tick, GameConfig.get(:world, :real_tick_rate))
   end

end
