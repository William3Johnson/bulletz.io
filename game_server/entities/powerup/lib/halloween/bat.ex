defmodule Powerup.Bat do
  def bat(state) do
    state |>
      Player.restore_state |>
      Map.put(:sprite, "bat.png") |>
      Map.put(:bullet_sprite, "bat.png") |>
      Map.put(:background_color, Map.get(state, :color)) |>
      Map.put(:acceleration, GameConfig.get(:player, :acceleration) * 1.3) |>
      Map.put(:shoot_callback, &bat_shoot/2) |>
      Map.put(:bullet_lifetime_mod, 0.35) |>
      Map.put(:bullet_damage_mod, 0.75)
  end

  def bat_shoot(player = %{mobile: true, x: x, y: y, target: %{x: dx, y: dy}}, world_state) do
    player |>
      Map.put(:mobile, false) |>
      Map.put(:target, %{x: x + dx, y: y + dy}) |>
      bat_shoot(world_state)
    player
  end
  def bat_shoot(player = %{x: x, y: y, target: %{x: target_x, y: target_y}}, world_state) do
    angle = :math.atan2(target_x - x, target_y - y)
    Enum.map(-1..1, fn n ->
      Bullet.new(player, world_state, %{angle: angle + n*:math.pi/40})
    end)

    player
  end

end
