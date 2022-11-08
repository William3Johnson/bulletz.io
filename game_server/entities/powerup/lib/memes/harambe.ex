defmodule Powerup.Harambe do
  def harambe(state) do
    state |>
      Player.restore_state |>
      Map.put(:sprite, "harambe.png") |>
      Map.put(:bullet_sprite, "poop.png") |>
      Map.put(:bullet_lifetime_mod, 0.75) |>
      Map.put(:bullet_size_mod, 3) |>
      Map.put(:bullet_damage_mod, 3) |>
      Map.put(:reload, GameConfig.get(:player, :reload)*2)
  end
end
