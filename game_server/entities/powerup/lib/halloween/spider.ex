defmodule Powerup.Spider do

  def spider(state) do
    state |>
      Player.restore_state |>
      Map.put(:sprite, "spider.png") |>
      Map.put(:background_color, Map.get(state, :color)) |>
      Map.put(:reload, GameConfig.get(:player, :reload)/2) |>
      Map.put(:acceleration, GameConfig.get(:player, :acceleration) * 0.85) |>
      Map.put(:bullet_size_mod, 0.66) |>
      Map.put(:bullet_damage_mod, 0.5) |>
      Map.put(:shoot_callback, &spider_shoot/2) |>
      Map.put(:extra_data, 0)
  end


  def spider_shoot(player = %{extra_data: spider_count}, world_state) when spider_count >= 4 do
    tmp_player = player |>
      Map.put(:bullet_size_mod, 4) |>
      Map.put(:bullet_color, :none) |>
      Map.put(:bullet_sprite, "spider_web.png")
    Bullet.new(tmp_player, world_state, %{extra_callbacks: [&apply_freeze/1]})
    Map.put(player, :extra_data, 0)
  end
  def spider_shoot(player, world_state) do
    Bullet.new(player, world_state)
    Map.update!(player, :extra_data, &(&1+1))
  end

  defp apply_freeze(player) do
    Map.put(player, :stuck, 100)
  end

end
