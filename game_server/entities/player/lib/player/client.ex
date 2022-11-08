defmodule Player.Client do

  def action(pid, activation, action) do
    GenServer.cast(pid, {:action, activation, action})
  end

  def action_direct(pid, direction, percentage) do
    GenServer.cast(pid, {:action_direct, direction, percentage})
  end

  def shoot(pid, target) do
    GenServer.cast(pid, {:shoot, target})
  end

  def effect(pid, effect) do
    GenServer.cast(pid, {:effect, effect})
  end

  def tick(pid, world_state) do
    GenServer.call(pid, {:tick, world_state})
  end

  def change_target(pid, target) do
    GenServer.cast(pid, {:change_target, target})
  end

end
