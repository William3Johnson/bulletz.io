defmodule Bot.Supervisor do
  use DynamicSupervisor

  def start_link() do
    DynamicSupervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def new(create_player) do
    spec = {Bot.Server, create_player: create_player}
    DynamicSupervisor.start_child(__MODULE__, spec)
  end

  @impl true
  def init(:ok) do
    DynamicSupervisor.init(
      strategy: :one_for_one,
      extra_arguments: []
    )
  end

end
