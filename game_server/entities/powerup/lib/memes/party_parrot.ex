defmodule Powerup.PartyParrot do
  @spritesheet %{
    image: "party_parrot_spritesheet.png",
    width: 128,
    height: 128,
    percent: 75,
    frames: 20,
    background: true
  }
  def party_parrot(state) do
    state |>
      Player.restore_state |>
      Map.put(:spritesheet, @spritesheet) |>
      Map.put(:shoot_callback, &party_parrot_shoot/2)
  end

  def party_parrot_shoot(%{target: nil}, _), do: nil
  def party_parrot_shoot(player = %{mobile: true, x: x, y: y, target: %{x: dx, y: dy}}, world_state) do
    player |>
      Map.put(:mobile, false) |>
      Map.put(:target, %{x: x + dx, y: y + dy}) |>
      party_parrot_shoot(world_state)

    player
  end
  def party_parrot_shoot(player = %{x: x, y: y, target: %{x: target_x, y: target_y}}, world_state) do
    angle = :math.atan2(target_x - x, target_y - y)

    nplayer = player |>
      Map.put(:color, ColorGen.random_color())

    Enum.map(-2..2, fn n ->
      Bullet.new(nplayer, world_state, %{angle: angle + n*:math.pi/40})
    end)

    player
  end
end
