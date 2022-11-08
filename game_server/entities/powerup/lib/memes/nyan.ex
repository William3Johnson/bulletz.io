defmodule Powerup.Nyan do
  @spritesheet %{
    image: "nyan_spritesheet.png",
    width: 400,
    height: 400,
    percent: 100,
    frames: 16,
    background: false
  }

  def nyan(state) do
    state |>
      Player.restore_state |>
      Map.put(:spritesheet, @spritesheet) |>
      Map.put(:shoot_callback, &nyan_shoot/2) |>
      Map.put(:acceleration, GameConfig.get(:player, :acceleration) * 2) |>
      Map.put(:bullet_lifetime_mod, 0.07) |>
      Map.put(:bullet_size_mod, 0.65) |>
      Map.put(:bullet_damage_mod, 0.25) |>
      Map.put(:growth_rate_mod, 0.5) |>
      Map.put(:bullet_end_speed_mod, 1.1) |>
      Map.put(:extra_data, %{angle: 0}) |>
      Map.put(:reload, GameConfig.get(:player, :reload)/15) |>
      Map.put(:hide_aim, true)
  end

  def nyan_shoot(player = %{extra_data: %{angle: angle}}, world_state) do
    nplayer = player |>
      Map.put(:color, ColorGen.random_color())

    Bullet.new(nplayer, world_state, %{angle: 0.5*angle, inherit_velocity: true})
    Bullet.new(nplayer, world_state, %{angle: angle, inherit_velocity: true})
    Bullet.new(nplayer, world_state, %{angle: 1.5 * angle, inherit_velocity: true})
    Bullet.new(nplayer, world_state, %{angle: 2 * angle, inherit_velocity: true})

    Map.put(player, :extra_data, %{angle: angle+0.1})
  end

end
