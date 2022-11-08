defmodule Pickup.Supervisor do
  use Supervisor

  def start(_opts, _args) do
    Supervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def new(kwargs) do
    Supervisor.start_child(__MODULE__, [kwargs])
  end

  def init(:ok) do
    children =[
      worker(Pickup.Server, [], restart: :temporary)
    ]
    opts = [
      strategy: :simple_one_for_one
    ]
    supervise(children, opts)
  end
end
