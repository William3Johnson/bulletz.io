defmodule Bullet.Transformations do

  def dx(%{bullet_size_mod: bullet_size_mod, radius: player_radius}) do
    bullet_rad = bullet_size_mod * (player_radius/GameConfig.get(:bullet, :parent_radius_ratio))
    bullet_rad + player_radius + 1
  end

  def transform_player(player, world_state, angle) do
    player |>
      update_x(angle) |>
      update_y(angle) |>
      limit_boundaries(world_state)
  end

  defp limit_boundaries(player, %{width: width, height: height} ) do
    player |>
      Map.update!(:x, &(min(&1, width))) |>
      Map.update!(:x, &(max(&1, 0))) |>
      Map.update!(:y, &(min(&1, height))) |>
      Map.update!(:y, &(max(&1, 0)))
  end

  defp update_x(player, angle) do
    sin = :math.sin(angle)
    dx = sin*dx(player)
    Map.update!(player, :x, fn x -> x + dx end)
  end
  defp update_y(player, angle) do
    cos = :math.cos(angle)
    dy = cos*dx(player)
    Map.update!(player, :y, fn y -> y + dy end)
  end

end
