defmodule Bullet.Supervisor do
  use Supervisor

  def start(_opts, _args) do
    Supervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def new(player, world_state) do
    Supervisor.start_child(__MODULE__, [player, world_state])
  end

  def new(player, world_state, optargs) do
    Supervisor.start_child(__MODULE__, [player, world_state, optargs])
  end

  def init(:ok) do
    children =[
      worker(Bullet.Server, [], restart: :temporary)
    ]
    opts = [
      strategy: :simple_one_for_one
    ]
    supervise(children, opts)
  end

end
