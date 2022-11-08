defmodule MovingFood.Supervisor do
  use Supervisor

  def start(_opts, _args) do
    Supervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def for_player_death(size, player, world_state) do
    Supervisor.start_child(__MODULE__, [%{damage: size * GameConfig.get(:moving_food, :player_death_ratio), size_mod: 1/GameConfig.get(:moving_food, :size_mod)}, player, world_state])
  end

  def from_hit(bullet, player, world_state) do
    Supervisor.start_child(__MODULE__, [bullet, player, world_state])
  end

  def init(:ok) do
    children =[
      worker(MovingFood.Server, [], restart: :temporary)
    ]
    opts = [
      strategy: :simple_one_for_one
    ]
    supervise(children, opts)
  end
end
