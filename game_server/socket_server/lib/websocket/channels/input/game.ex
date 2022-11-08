defmodule SocketServer.Input.Game do
    def game_handle_in("shoot", body = %{"x" => _x, "y" => _y}, socket = %{assigns: %{player: player}}) do
      Player.shoot(player, body)
      {:noreply, socket}
    end
    def game_handle_in("target", body = %{"x" => _x, "y" => _y}, socket = %{assigns: %{player: player}}) do
      Player.change_target(player, body)
      {:noreply, socket}
    end

    def game_handle_in("mobile_movement", %{"up" => up, "down" => down, "left" => left, "right" => right}, socket = %{assigns: %{player: player}}) do
      Player.action_direct(player, :up, min(1,up))
      Player.action_direct(player, :down, min(1, down))
      Player.action_direct(player, :left, min(1, left))
      Player.action_direct(player, :right, min(1, right))
      {:noreply, socket}
    end

    def game_handle_in("down", %{"action" => action}, socket = %{assigns: %{player: player}}) do
      action = String.to_existing_atom(action)
      handle_action(player, :down, action)
      {:noreply, socket}
    end
    def game_handle_in("up", %{"action" => action}, socket = %{assigns: %{player: player}}) do
      action = String.to_existing_atom(action)
      handle_action(player, :up, action)
      {:noreply, socket}
    end

    def game_handle_in(_activation, _body, socket) do
      {:reply, :error, socket}
    end

    defp handle_action(_player, _,          nil),    do: nil
    defp handle_action( player, activation, action), do: Player.action(player, activation, action)
end
