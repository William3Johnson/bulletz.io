defmodule Player.Shoot do

  defp shoot(player = %{shoot_callback: shoot_callback, reload: reload}, world_state) do
    shoot_callback.(player, world_state) |>
      Map.put(:reload_time, reload)
  end

  def shoot_if_shooting(player = %{reload_time: r}, world_state) when r <= 0 do
    shoot(player, world_state)
  end
  def shoot_if_shooting(player, _), do: player

end
