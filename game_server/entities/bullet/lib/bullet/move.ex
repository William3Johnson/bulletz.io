defimpl Move, for: Bullet do

  defp update_origin(bullet = %{x: x, y: y}) do
    bullet |>
      Map.put(:x_origin, x) |>
      Map.put(:y_origin, y)
  end

  defp handle_reversals_x(bullet = %{x: x}, dx, width) when x + dx > width or x + dx < 0 do
    bullet |>
      Map.update!(:velocity_x, &(-&1)) |>
      Map.update!(:vx_slowdown, &(-&1)) |>
      update_origin()
  end
  defp handle_reversals_x(bullet, _dx, _width), do: bullet

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

  defp move_x(bullet, width, ticks) do
    bullet = handle_reversals_x(bullet, get_vx(bullet)*ticks, width)
    dx = get_vx(bullet)*ticks
    Map.update!(bullet, :x, &(&1+dx))
  end
  defp move_y(bullet, height, ticks) do
    bullet = handle_reversals_y(bullet, get_vy(bullet)*ticks, height)
    dy = get_vy(bullet)*ticks
    Map.update!(bullet, :y, &(&1+dy))
  end

  defp update_prev(bullet = %{velocity_x: vx, velocity_y: vy}) do
    bullet |>
      Map.put(:velocity_x_prev, vx) |>
      Map.put(:velocity_y_prev, vy)
  end

  defp slowdown_vx(bullet = %{velocity_x: 0}, _ticks), do: bullet
  defp slowdown_vx(bullet = %{vx_slowdown: vxs, velocity_x: vx}, ticks) do
    bullet |>
      Map.put(:velocity_x, vx - vxs*ticks)
  end

  defp slowdown_vy(bullet = %{velocity_y: 0}, _ticks), do: bullet
  defp slowdown_vy(bullet = %{vy_slowdown: vys, velocity_y: vy}, ticks) do
    bullet |>
      Map.put(:velocity_y, vy - vys*ticks)
  end

  defp slowdown(bullet = %{age: age, slowdown_duration: slowdown_duration}, _ticks) when age > slowdown_duration do
    bullet |>
      Map.put(:velocity_x, 0) |>
      Map.put(:velocity_y, 0) |>
      Map.put(:velocity_y_prev, 0) |>
      Map.put(:velocity_x_prev, 0)
  end
  defp slowdown(bullet, ticks) do
    bullet |>
      slowdown_vx(ticks) |>
      slowdown_vy(ticks)
  end

  def move(bullet, %{width: width, height: height}, ticks) do
    bullet |>
      move_x(width, ticks) |>
      move_y(height, ticks) |>
      update_prev() |>
      slowdown(ticks)
  end

end
