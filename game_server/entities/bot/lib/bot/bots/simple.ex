defmodule Bot.Simple do
  def find_target(player, players) do
    Bot.Util.closest_player(player, players)
  end

  def random_move() do
    Enum.random([0, 1])
  end

  def should_stop() do
    true
  end

  def movements(), do: movements(nil, nil)
  def movements(_player, _player_state) do
    movements = %{up: up, down: down, left: left, right: right} = Map.merge(left_right_movement(), up_down_movement())
    if (up - down) == 0 and (left - right) == 0 do
      Enum.random([
        %{up: 1, down: 0, left: 0, right: 0},
        %{up: 0, down: 1, left: 0, right: 0},
        %{up: 0, down: 0, left: 1, right: 0},
        %{up: 0, down: 0, left: 0, right: 1}
        ])
    else
      movements
    end
  end

  defp left_right_movement() do
    %{left: random_move(), right: random_move()}
  end

  defp up_down_movement() do
    %{up: random_move(), down: random_move()}
  end
end
