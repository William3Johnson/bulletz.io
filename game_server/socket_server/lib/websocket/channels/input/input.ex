defmodule SocketServer.Input do
    use Phoenix.Channel, log_join: false, log_handle_in: false

    def join("input", _message, socket) do
      if length(Peek.peek(SocketServer.Connector.world) |> Map.get(:players)) >= GameConfig.get(:world, :max_players) do
        {:error, %{message: "World full"}}
      else
        { :ok, assign(socket, :player, nil)}
      end
    end

    defp validate_name(""), do: NameGen.random()
    defp validate_name(other), do: other

    def handle_in("join", %{"name" => name, "mobile" => mobile}, socket = %{assigns: %{player: nil}}) when is_bitstring(name) do
      if length(Peek.peek(SocketServer.Connector.world) |> Map.get(:players)) >= GameConfig.get(:world, :max_players) do
        {:reply, {:error, %{message: "World full"}}, socket}
      else
        {:ok, player} = SocketServer.Connector.new_player(name: validate_name(name), mobile: mobile)
        {:reply, {:ok, Peek.peek(player)}, assign(socket, :player, player)}
      end
    end

    def handle_in("join", %{"name" => name, "mobile" => mobile}, socket = %{assigns: %{player: player}}) when is_bitstring(name) do
      if Process.alive?(player) do
        {:reply, {:ok, Peek.peek(player)}, socket}
      else
        handle_in("join", %{"name" => name, "mobile" => mobile}, assign(socket, :player, nil))
      end
    end

    def handle_in("heartbeat", _, socket = %{assigns: %{player: player}}) do
      if(!Process.alive?(player)) do
        {:reply, :error, socket}
      else
        {:reply, :ok, socket}
      end
    end

    def handle_in(msg, body, socket) do
      SocketServer.Input.Game.game_handle_in(msg, body, socket)
    end

end
