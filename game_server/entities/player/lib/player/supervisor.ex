defmodule Player.Supervisor do
  use Supervisor

  def start(_opts, _args) do
    Supervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end
  def new(opts) do
    Supervisor.start_child(__MODULE__, [opts])
  end

  def init(:ok) do
    children =[
      worker(Player.Server, [], restart: :temporary)
    ]
    opts = [
      strategy: :simple_one_for_one
    ]
    supervise(children, opts)
  end

end
