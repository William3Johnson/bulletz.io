defmodule Player.Server do
  use GenServer
  alias Player.Impl, as: Impl

  defdelegate init(args), to: Player.Init
  defdelegate start_link(opts), to: Player.Init

  def handle_call({:peek}, _from, state) do
    {:reply, state, state}
  end

  def handle_call({:tick, world_state}, _from, state) do
    Impl.tick(state, world_state)
  end

  def handle_cast({:change_target, target}, state) do
    {:noreply, Impl.change_target(state, target)}
  end

  def handle_cast({:action, activation, action}, state) do
    {:noreply, Impl.action(state, activation, action)}
  end

  def handle_cast({:action_direct, direction, percentage}, state) do
    {:noreply, Impl.action_direct(state, direction, percentage)}
  end

  def handle_cast({:effect, effect}, state) do
    {:noreply, Impl.effect(state, effect)}
  end

  def handle_cast({:shoot, target}, state) do
    {:noreply, Impl.handle_shoot(state, target)}
  end

end
