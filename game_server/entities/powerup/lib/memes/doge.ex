defmodule Powerup.Doge do
  def doge(state) do
    state |>
      Player.restore_state |>
      Map.put(:sprite, "doge.png") |>
      Map.put(:shoot_callback, &doge_shoot/2) |>
      Map.put(:bullet_damage_mod, 0.5) |>
      Map.put(:bullet_lifetime_mod, 0.5) |>
      Map.put(:bullet_size_mod, 0.5) |>
      Map.put(:reload, GameConfig.get(:player, :reload)/7.5)
  end

  def doge_shoot(%{target: nil}, _), do: nil
  def doge_shoot(player, world_state) do
    nplayer = player |>
      Map.put(:color, ColorGen.random_color())

    Bullet.new(nplayer, world_state)
    player
  end
end
