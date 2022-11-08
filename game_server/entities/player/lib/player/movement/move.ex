defimpl Move, for: Player do

  defp velocity_mod_x(player = %{radius: radius, x: x, velocity_x: vx}, world_bound) when x == radius or x == world_bound-radius and vx > 0 do
    Map.put(player, :velocity_x, 0)
  end
  defp velocity_mod_x(player, _world_bound), do: player

  defp velocity_mod_y(player = %{radius: radius, y: y, velocity_y: vy}, world_bound) when y == radius or y == world_bound-radius and vy > 0 do
    Map.put(player, :velocity_y, 0)
  end
  defp velocity_mod_y(player, _world_bound), do: player

  defp validate(x, radius, _world_bound) when x < radius do
    radius
  end
  defp validate(x, radius, world_bound) when x > world_bound-radius do
    world_bound-radius
  end
  defp validate(x, _1, _2), do: x

  defp average(n1, n2), do: n1/2 + n2/2

  defp calc_move_x(%{x: x, velocity_x: velocity_x, velocity_x_prev: prev_vx, radius: radius}, world_width, ticks) do
    dx = average(velocity_x, prev_vx)*ticks
    validate(x + dx, radius, world_width)
  end
  defp calc_move_y(%{y: y, velocity_y: velocity_y, velocity_y_prev: prev_vy, radius: radius}, world_height, ticks) do
    dy = average(velocity_y, prev_vy)*ticks
    validate(y + dy, radius, world_height)
  end

  # Normal movement
  def move(player = %{stuck: s}, %{width: world_width, height: world_height}, ticks) when s <= 0 do
    player |>
      Map.put(:x, calc_move_x(player, world_width, ticks)) |>
      Map.put(:y, calc_move_y(player, world_height, ticks)) |>
      velocity_mod_x(world_width) |>
      velocity_mod_y(world_height)
  end

  # Stuck from spider web
  def move(player = %{x: x, y: y, radius: radius, stuck: s}, %{width: world_width, height: world_height}, ticks) do
    player |>
      Map.put(:x, validate(x, radius, world_width)) |>
      Map.put(:y, validate(y, radius, world_height)) |>
      Map.put(:velocity_x, 0) |>
      Map.put(:velocity_y, 0) |>
      Map.put(:stuck, max(s - ticks, 0))
  end
end
