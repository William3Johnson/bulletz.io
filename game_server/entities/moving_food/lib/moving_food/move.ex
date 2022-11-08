defimpl Move, for: MovingFood do

  defp update_origin(food = %{x: x, y: y}) do
    food |>
      Map.put(:x_origin, x) |>
      Map.put(:y_origin, y)
  end

  defp handle_reversals_x(food = %{x: x}, dx, width) when x + dx > width or x + dx < 0 do
    food |>
      Map.update!(:velocity_x, &(-&1)) |>
      Map.update!(:vx_slowdown, &(-&1)) |>
      update_origin()
  end
  defp handle_reversals_x(food, _dx, _width), do: food

  defp handle_reversals_y(player = %{y: y}, dy, height) when y + dy > height or y + dy < 0 do
    player |>
      Map.update!(:velocity_y, &(-&1)) |>
      Map.update!(:vy_slowdown, &(-&1)) |>
      update_origin()
  end
  defp handle_reversals_y(player, _dy, _width), do: player

  defp get_vx(%{velocity_x: velocity_x, velocity_x_prev: velocity_x_prev}) do
    (velocity_x + velocity_x_prev)/2
  end
  defp get_vy(%{velocity_y: velocity_y, velocity_y_prev: velocity_y_prev}) do
    (velocity_y + velocity_y_prev)/2
  end

  defp move_x(food, width, ticks) do
    food = handle_reversals_x(food, get_vx(food)*ticks, width)
    dx = get_vx(food)*ticks
    Map.update!(food, :x, &(&1+dx))
  end
  defp move_y(food, height, ticks) do
    food = handle_reversals_y(food, get_vy(food)*ticks, height)
    dy = get_vy(food)*ticks
    Map.update!(food, :y, &(&1+dy))
  end

  defp update_prev(food = %{velocity_x: vx, velocity_y: vy}) do
    food |>
      Map.put(:velocity_x_prev, vx) |>
      Map.put(:velocity_y_prev, vy)
  end

  defp slowdown_vx(food = %{velocity_x: 0}, _ticks), do: food
  defp slowdown_vx(food = %{vx_slowdown: vxs, velocity_x: vx}, ticks) do
    food |>
      Map.put(:velocity_x, vx - vxs*ticks)
  end

  defp slowdown_vy(food = %{velocity_y: 0}, _ticks), do: food
  defp slowdown_vy(food = %{vy_slowdown: vys, velocity_y: vy}, ticks) do
    food |>
      Map.put(:velocity_y, vy - vys*ticks)
  end

  defp slowdown(food = %{age: age, slowdown_duration: slowdown_duration}, _ticks) when age > slowdown_duration do
    food |>
      Map.put(:velocity_x, 0) |>
      Map.put(:velocity_y, 0) |>
      Map.put(:velocity_y_prev, 0) |>
      Map.put(:velocity_x_prev, 0)
  end
  defp slowdown(food, ticks) do
    food |>
      slowdown_vx(ticks) |>
      slowdown_vy(ticks)
  end

  def move(food, %{width: width, height: height}, ticks) do
    food |>
      move_x(width, ticks) |>
      move_y(height, ticks) |>
      update_prev() |>
      slowdown(ticks)
  end

end
