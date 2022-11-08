defmodule Player.Velocity do
  def update_velocity(player = %{velocity_x: vx, velocity_y: vy}, ticks) do
    {fdx, fdy} = get_friction(player, ticks)
    player |>
      update_velocity_x(vx, ticks) |>
      update_velocity_y(vy, ticks) |>
      Map.update!(:velocity_x, &(&1-fdx)) |>
      Map.update!(:velocity_y, &(&1-fdy)) |>
      Map.put(:velocity_x_prev, vx) |>
      Map.put(:velocity_y_prev, vy)
  end

  defp get_friction(%{velocity_x: vx, velocity_y: vy, velocity_x_prev: vxp, velocity_y_prev: vyp, friction: friction, frost: frost}, ticks) do
    avg_vx = (vx + vxp)/2
    avg_vy = (vy + vyp)/2
    velocity_magnitude = :math.sqrt(:math.pow(avg_vy, 2) + :math.pow(avg_vx, 2))

    if velocity_magnitude != 0 do
        friction_magnitude = velocity_magnitude * (friction + frost)
        friction_x = friction_magnitude * avg_vx/velocity_magnitude
        friction_y = friction_magnitude * avg_vy/velocity_magnitude
        {friction_x * ticks, friction_y * ticks}
      else
        {0, 0}
    end

  end

  defp update_velocity_x(player = %{left: accel_left, right: accel_right}, vx, ticks) do
    %{acceleration: acceleration} = player
    total_accel = min(1, accel_left)*acceleration - min(1, accel_right)*acceleration;
    Map.put(player, :velocity_x, vx - ticks*total_accel)
  end

  defp update_velocity_y(player = %{up: accel_up, down: accel_down}, vy, ticks) do
    %{acceleration: acceleration} = player
    total_accel = -min(1, accel_down)*acceleration + min(1, accel_up)*acceleration
    Map.put(player, :velocity_y, vy - ticks*total_accel)
  end

end
