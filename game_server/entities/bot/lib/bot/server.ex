defmodule Bot.Server do
  use GenServer
  alias Bot.Impl

  @schedule_movement_interval 500
  @world_boundaries_interval 300
  @shoot_interval 200

  def start_link(create_player: create_player) do
    backend = Impl.random_backend()
    GenServer.start(__MODULE__, %{create_player: create_player, backend: backend, player: Impl.new_player(create_player, backend)})
  end

  def init(state = %{player: player}) do
    {:noreply, state} = Impl.update_movement(state, Peek.peek(player))
    schedule_movement()
    schedule_check_world_boundaries()
    schedule_shoot()
    {:ok, state}
  end

  def handle_info(_, nil) do
    {:stop, :normal, nil}
  end
  def handle_info(message, state = %{player: player}) do
    do_handle_info(message, state, Peek.peek(player))
  end

  def do_handle_info(_message, _state, nil) do
    {:stop, :normal, nil}
  end

  def do_handle_info(:update, state, player) do
    result = Impl.update_movement(state, player)
    schedule_movement()
    result
  end

  def do_handle_info(:check_boundaries, state, player) do
    result = Impl.check_world_boundaries(state, player)
    schedule_check_world_boundaries()
    result
  end

  def do_handle_info(:shoot, state, player) do
    result = Impl.shoot(state, player)
    schedule_shoot()
    result
  end

  def do_handle_info(_, _state, _2) do
    {:stop, :normal, nil}
  end

  defp schedule_movement() do
    Process.send_after(self(), :update, @schedule_movement_interval + trunc(:rand.uniform * @schedule_movement_interval))
  end
  defp schedule_check_world_boundaries() do
    Process.send_after(self(), :check_boundaries, @world_boundaries_interval)
  end
  defp schedule_shoot() do
    Process.send_after(self(), :shoot, @shoot_interval + trunc(:rand.uniform * @shoot_interval))
  end

end
