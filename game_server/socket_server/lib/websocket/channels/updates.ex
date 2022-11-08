defmodule SocketServer.Updates do
  use Phoenix.Channel, log_join: false, log_handle_in: false

  def join("updates", _message, socket) do
    { :ok, socket }
  end

  def not_nil val do
    val != nil
  end
  def broadcast_kill(id) do
    SocketServer.Endpoint.broadcast("updates", "remove_player", %{id: id})
  end

  def broadcast_bullet(bullet) do
    SocketServer.Endpoint.broadcast("updates", "create_bullet", bullet)
  end

  def broadcast_food(food) do
    SocketServer.Endpoint.broadcast("updates", "create_food", food)
  end
  def broadcast_remove_food(id) do
    SocketServer.Endpoint.broadcast("updates", "remove_food", %{id: id})
  end

  def broadcast_moving_food(food) do
    SocketServer.Endpoint.broadcast("updates", "create_moving_food", food)
  end
  def broadcast_remove_moving_food(id) do
    SocketServer.Endpoint.broadcast("updates", "remove_moving_food", %{id: id})
  end

  def broadcast_pickup(pickup) do
    SocketServer.Endpoint.broadcast("updates", "create_pickup", pickup)
  end
  def broadcast_remove_pickup(id) do
    SocketServer.Endpoint.broadcast("updates", "remove_pickup", %{id: id})
  end

  def broadcast_player(player) do
    SocketServer.Endpoint.broadcast("updates", "create_player", player)
  end

  def broadcast_remove_bullet(%{id: id}) do
    SocketServer.Endpoint.broadcast("updates", "remove_bullet", %{id: id})
  end

  def broadcast_scoreboard(scoreboard) do
    SocketServer.Endpoint.broadcast("updates", "scoreboard", %{scoreboard: scoreboard})
  end

  defp poll() do
    %{bullets: bullets, players: players, pickups: pickups, food: food, moving_food: moving_food, world: world} = SocketServer.Connector.state
    bullets = Enum.map(bullets, &Peek.peek/1) |> Enum.filter(&not_nil/1) |> map_by_key(:id)
    players = Enum.map(players, &Peek.peek/1) |> Enum.filter(&not_nil/1) |> map_by_key(:id)
    pickups = Enum.map(pickups, &Peek.peek/1) |> Enum.filter(&not_nil/1) |> map_by_key(:id)
    moving_food = Enum.map(moving_food, &Peek.peek/1) |> Enum.filter(&not_nil/1) |> map_by_key(:id)
    food =  food |> map_by_key(:id)
    %{bullets: bullets, players: players, food: food, moving_food: moving_food, pickups: pickups, world: world}
  end

  defp map_by_key(items, key) do
    items |>
      Enum.reduce(%{}, fn element, acc ->
        Map.put(acc, Map.get(element, key), element)
      end)
  end

  def broadcast_poll() do
    SocketServer.Endpoint.broadcast("updates", "poll", poll())
  end

  def handle_in("request_scoreboard", _msg, socket) do
    {:reply, {:ok, %{scoreboard: []}}, socket}
  end

  def handle_in("poll", _msg, socket) do
    {:reply, {:ok, poll()}, socket}
  end

end
