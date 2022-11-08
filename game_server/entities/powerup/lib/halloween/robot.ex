defmodule Powerup.Robot do
  def robot(state) do
    state |>
      Player.restore_state |>
      Map.put(:sprite, "robot.png") |>
      Map.put(:shoot_callback, &robot_shoot/2) |>
      Map.put(:reload, GameConfig.get(:player, :reload)/1.2) |>
      Map.put(:extra_data, 0)
  end


  def robot_shoot(player = %{extra_data: count}, world_state) when count >= 6 do
    Bullet.new(player, world_state)
    pow(player, world_state)
    Map.put(player, :extra_data, 0)
  end
  def robot_shoot(player, world_state) do
    Bullet.new(player, world_state)
    Map.update!(player, :extra_data, &(&1+1))
  end

  def pow(player, world_state) do
    player = Map.put(player, :bullet_sprite, "lightning.png") |>
      Map.put(:bullet_size_mod, 3) |>
      Map.put(:bullet_lifetime_mod, 0.15) |>
      Map.put(:bullet_color, :none)

    max=36
    0..max |>
      Enum.map(fn n ->
        angle = n*(2*:math.pi/(max))
        Bullet.new(player, world_state, %{angle: :math.pi * angle, inherit_velocity: true})
      end)

    player
  end

end
