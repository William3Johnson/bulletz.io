defmodule Bot.Medium do

  def find_target(player_state, players) do
    Bot.Util.closest_player(player_state, players)
  end

  def movements(player_state, world) do
    %{players: players, moving_food: moving_foods} = Peek.peek(world)
    inner_find_movements(player_state, Bot.Util.closest_player(player_state, players), Bot.Util.closest_moving_food(player_state, moving_foods))
  end

  defp inner_find_movements(player, opponent, nil), do: opponent_based_movement(player, opponent)
  defp inner_find_movements(_1, nil, _), do: Bot.Simple.movements()
  defp inner_find_movements(player = %{radius: radius}, opponent = %{radius: opponent_radius}, closest_food = %{radius: food_radius}) do
    food_dist = :math.sqrt(Collisions.squared_distance(closest_food, player)) - (radius+food_radius)
    opponent_dist = :math.sqrt(Collisions.squared_distance(opponent, player)) - (opponent_radius+radius)
    cond do
      opponent_dist < 25 and radius > opponent_radius ->
        run_from_player(player, opponent)
      opponent_dist < 125 and radius > opponent_radius ->
        chase_player(player, opponent)
      food_dist < 125 ->
        move_to_food(player, closest_food)
      radius > opponent_radius ->
          chase_player(player, opponent)
      opponent_dist < 1500 and radius < opponent_radius ->
        run_from_player(player, opponent)
      true ->
        Bot.Simple.movements()
    end
  end

  defp opponent_based_movement(_, nil), do: Bot.Simple.movements()
  defp opponent_based_movement(player = %{radius: radius}, opponent = %{radius: opponent_radius}) do
    cond do
      radius > opponent_radius ->
        chase_player(player, opponent)
      :math.sqrt(Collisions.squared_distance(opponent, player)) < (500 - (opponent_radius+radius)) and radius < opponent_radius ->
        run_from_player(player, opponent)
      true ->
        Bot.Simple.movements()
    end
  end

  defp run_from_player(player, opponent) do
    find_chasing_movements(player, opponent) |>
      direction_shift(-1) |>
      package_to_movements()
  end
  defp chase_player(player, opponent) do
    find_chasing_movements(player, opponent) |>
      package_to_movements()
  end

  defp move_to_food(%{x: x, y: y}, closest_food) do
    %{x: food_x, y: food_y} = closest_food
    dx = food_x - x
    dy = food_y - y
    normalize_x_y(dx, dy) |>
      package_to_movements()
  end

  defp normalize_x_y(x, y) do
    total = abs(x) + abs(y)
    %{x: x/total, y: y/total}
  end

  defp package_to_movements(movements) do
    horizontal_movements(movements) |>
      vertical_movements(movements)
  end

  defp horizontal_movements(%{x: x}) when x > 0 do
    %{right: x, left: 0}
  end
  defp horizontal_movements(%{x: x}) when x < 0 do
    %{right: 0, left: -x}
  end
  defp horizontal_movements(_), do: %{right: 0, left: 0}

  defp vertical_movements(movement, %{y: y}) when y > 0 do
      Map.merge(movement, %{down: y, up: 0})
  end
  defp vertical_movements(movement, %{y: y}) when y < 0 do
    Map.merge(movement, %{down: 0, up: -y})
  end
  defp vertical_movements(movement, _), do:   Map.merge(movement, %{right: 0, left: 0})

  defp direction_shift(%{x: x, y: y}, direction) do
    %{x: x*direction, y: y*direction}
  end

  defp find_chasing_movements(%{x: x, y: y}, %{x: x2, y: y2}) do
    %{x: one_or_negative(x < x2), y: one_or_negative(y < y2)}
  end

  defp one_or_negative(true), do: 1
  defp one_or_negative(_false), do: -1
end
