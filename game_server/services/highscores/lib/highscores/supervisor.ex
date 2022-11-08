defmodule Highscores.Supervisor do
  use Supervisor
  def start_link() do
    Supervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def start_link(__unused__) do
    start_link()
  end

  def init(:ok) do
    children = [
      worker(Highscores.Server, [], restart: :permanent),
    ]

    opts = [strategy: :one_for_one]
    supervise(children, opts)
  end

end
