defmodule Player.ShootCallbacks do

  def default_shoot(%{target: nil}, _), do: nil
  def default_shoot(player, world_state) do
    Bullet.new(player, world_state)
    player
  end

  def inherit_velocity(%{target: nil}, _), do: nil
  def inherit_velocity(player, world_state) do
    Bullet.new(player, world_state, %{inherit_velocity: true})
    player
  end

end
