defmodule Powerup.UgandanKnuckles do
  def ugandan_knuckles(state) do
    state |>
      Player.restore_state |>
      Map.put(:sprite, "ugandan_knuckles.png") |>
      Map.put(:bullet_lifetime_mod, 0.05) |>
      Map.put(:reload, GameConfig.get(:player, :reload)/10) |>
      Map.put(:acceleration, GameConfig.get(:player, :acceleration) * 1.25) |>
      Map.put(:shoot_callback, &Player.ShootCallbacks.inherit_velocity/2) |>
      Map.put(:bullet_damage_mod, 0.55)
  end
end
