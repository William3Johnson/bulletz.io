defmodule Bullet.Init do
  alias Bullet.Transformations, as: Transformations

  def init(state = %{world: world}) do
    World.new_bullet(world, self(), state)
    {:ok, state}
  end

  def start_link(player, world_state) do
    GenServer.start_link(Bullet.Server, initial_state(player, world_state, %{}))
  end
  def start_link(player, world_state, optargs) do
    GenServer.start_link(Bullet.Server, initial_state(player, world_state, optargs))
  end

  defp shared_initial_state(%{
      world: world,
      id: parent_id,
      radius: parent_radius,
      name: parent_name,
      color: color,
      bullet_sprite: bullet_sprite,
      bullet_color: bullet_color,
      bullet_damage_mod: bullet_damage_mod,
      bullet_size_mod: bullet_size_mod,
      bullet_lifetime_mod: bullet_lifetime_mod,
      bullet_slowdown_duration_mod: bullet_slowdown_duration_mod
    }) do
    color = bullet_color || color
    %Bullet{
      world: world,
      timestamp: :erlang.system_time(:milli_seconds),
      radius: bullet_size_mod * (parent_radius/GameConfig.get(:bullet, :parent_radius_ratio)),
      damage: get_damage(parent_radius, bullet_damage_mod),
      parent_id: parent_id,
      parent_name: parent_name,
      color: color,
      lifetime: GameConfig.get(:bullet, :lifetime) * bullet_lifetime_mod,
      sprite: bullet_sprite,
      id: UUID.uuid1(),
      slowdown_duration: GameConfig.get(:bullet, :slowdown_duration) * bullet_slowdown_duration_mod
    }
  end

  defp add_extra_callbacks(bullet, %{extra_callbacks: extra_callbacks}), do: Map.put(bullet, :extra_callbacks, extra_callbacks)
  defp add_extra_callbacks(bullet, _), do: bullet

  defp get_damage(parent_radius, bullet_damage_mod) do
    bullet_damage_mod * :math.sqrt(parent_radius) * GameConfig.get(:bullet, :global_damage_mod)
  end

  defp initial_speed(state, angle) do
    speed = GameConfig.get(:bullet, :speed)
    vx = :math.sin(angle) * speed
    vy = :math.cos(angle) * speed

    %{state | velocity_x: vx, velocity_y: vy, speed: speed}
  end

  defp initial_x_y(state, player, world_state, angle) do
    %{x: x, y: y} = Transformations.transform_player(player, world_state, angle)
    %{state | x: x, y: y}
  end

  defp inner_initial_state(player, world_state, optargs = %{angle: angle}) do
    shared_initial_state(player) |>
      initial_speed(angle) |>
      initial_x_y(player, world_state, angle) |>
      add_extra_callbacks(optargs) |>
      add_prev_velocity() |>
      apply_speed_mod(player) |>
      apply_inherit_velocity(player, optargs) |>
      apply_end_speed_mod(player) |>
      apply_slowdown(player) |>
      update_origin()
  end

  defp initial_state(player, world_state, optargs = %{angle: _angle}) do
    inner_initial_state(player, world_state, optargs)
  end

  defp initial_state(player = %{mobile: true, x: x, y: y, target: %{x: dx, y: dy}}, world_state, optargs) do
    player |>
      Map.put(:mobile, false) |>
      Map.put(:target, %{x: x+dx, y: y+dy}) |>
      initial_state(world_state, optargs)
  end

  defp initial_state(player = %{x: x, y: y, target: %{x: target_x, y: target_y}}, world_state, optargs) do
    angle = :math.atan2(target_x - x, target_y - y)
    initial_state(player, world_state, Map.put(optargs, :angle, angle))
  end

  defp apply_end_speed_mod(bullet = %{velocity_x: vx, velocity_y: vy}, %{bullet_end_speed_mod: bullet_speed_mod}) do
    bullet |>
      Map.put(:velocity_x, vx * bullet_speed_mod) |>
      Map.put(:velocity_y, vy * bullet_speed_mod)
  end
  defp apply_end_speed_mod(bullet, _) do
    bullet
  end

  defp apply_speed_mod(bullet = %{velocity_x: vx, velocity_y: vy}, %{bullet_speed_mod: bullet_speed_mod}) do
    bullet |>
      Map.put(:velocity_x, vx * bullet_speed_mod) |>
      Map.put(:velocity_y, vy * bullet_speed_mod)
  end
  defp apply_speed_mod(bullet, _) do
    bullet
  end

  defp apply_inherit_velocity(bullet = %{velocity_x: vx, velocity_y: vy}, %{velocity_x: player_vx, velocity_y: player_vy}, %{inherit_velocity: true}) do
    bullet |>
      Map.put(:velocity_x, vx + player_vx) |>
      Map.put(:velocity_y, vy + player_vy)
  end
  defp apply_inherit_velocity(bullet, _player, _optargs) do
    bullet
  end

  defp add_prev_velocity(bullet = %{velocity_x: vx, velocity_y: vy}) do
    bullet |>
      Map.put(:velocity_x_prev, vx) |>
      Map.put(:velocity_y_prev, vy)
  end

  defp apply_slowdown(bullet = %{velocity_x: vx, velocity_y: vy}, %{bullet_slowdown_duration_mod: bullet_slowdown_duration_mod}) do
    slowdown_duration = GameConfig.get(:bullet, :slowdown_duration) * bullet_slowdown_duration_mod

    bullet |>
      Map.put(:vx_slowdown, vx/slowdown_duration) |>
      Map.put(:vy_slowdown, vy/slowdown_duration)
  end

  defp update_origin(bullet = %{x: x, y: y}) do
    bullet |>
      Map.put(:x_origin, x) |>
      Map.put(:y_origin, y)
  end
end
