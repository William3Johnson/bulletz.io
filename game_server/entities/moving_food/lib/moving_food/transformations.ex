defmodule MovingFood.Transformations do

  def dx(%{radius: player_radius}, food_radius) do
    food_radius + player_radius + 1
  end

  def transform_player(player, food_radius, world_state, angle) do
    player |>
      update_x(food_radius, angle) |>
      update_y(food_radius, angle) |>
      limit_boundaries(world_state)
  end

  defp limit_boundaries(player, %{width: width, height: height}) do
    player |>
      Map.update!(:x, &(min(&1, width))) |>
      Map.update!(:x, &(max(&1, 0))) |>
      Map.update!(:y, &(min(&1, height))) |>
      Map.update!(:y, &(max(&1, 0)))
  end

  defp update_x(player, food_radius, angle) do
    sin = :math.sin(angle)
    dx = sin*dx(player, food_radius)
    Map.update!(player, :x, fn x -> x + dx end)
  end
  defp update_y(player, food_radius, angle) do
    cos = :math.cos(angle)
    dy = cos*dx(player, food_radius)
    Map.update!(player, :y, fn y -> y + dy end)
  end

end
