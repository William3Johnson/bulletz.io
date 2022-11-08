defmodule Bullet.Server do
  use GenServer
  alias Bullet.Impl, as: Impl

  defdelegate start_link(player, world_state), to: Bullet.Init
  defdelegate start_link(player, world_state, angle), to: Bullet.Init
  defdelegate init(state), to: Bullet.Init

  def handle_call({:peek}, _from, state) do
    {:reply, state, state}
  end
  def handle_call({:tick, world_state}, _from, state) do
    Impl.tick(state, world_state)
  end
  def handle_cast(:stop, state) do
    {:stop, :normal, state}
  end

end
