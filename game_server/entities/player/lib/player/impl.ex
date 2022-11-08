defmodule Player.Impl do

  def update(player = %{update_callback: nil}), do: player
  def update(player = %{update_callback: update}) do
    update.(player)
    player
  end

  def handle_shoot(player, %{"x" => x, "y" => y}) do
    handle_shoot(player, %{x: x, y: y})
  end
  def handle_shoot(player, %{x: x, y: y}) do
    player |>
      Map.put(:target, %{x: x, y: y}) |>
      refresh_timer()
  end

  def change_target(player, %{"x" => x, "y" => y}) do
    Map.put(player, :target, %{x: x, y: y}) |>
      refresh_timer()
  end

  def increment_age(player = %{age: age}, max_age, _ticks) when age >= max_age do
    player
  end
  def increment_age(player, _max_age, ticks) do
    Map.update!(player, :age, &(&1+ticks))
  end

  defp update_if_consume(player, []), do: player
  defp update_if_consume(player, _), do: update(player)

  defp apply_food(player) do
    food_to_consume = FoodBucketizer.relevant_buckets(player) |>
      Enum.filter(fn food -> Collisions.circle_collision?(player, food) end)

    {Enum.reduce(food_to_consume, player, &Food.consume_food/2), food_to_consume}
  end

  def tick(player = %{death_mark: true, death_mark_timer: death_mark_timer}, _) when death_mark_timer > 0 do
    {ticks, player} = Ticks.elapsed_ticks(player)
    {:noreply, Map.put(player, :death_mark_timer, death_mark_timer-ticks)}
  end
  def tick(player = %{death_mark: true}, _) do
    kill_player(player)
    {:stop, :normal, :ok, player}
  end
  def tick(
    player = %{extra_callbacks: extra_callbacks},
    world_state = %{bullet_bucketizer: bullet_bucketizer, moving_food_bucketizer: moving_food_bucketizer, pickups_bucketizer: pickups_bucketizer}
    ) do
    {ticks, player} = Ticks.elapsed_ticks(player)
    player = Enum.reduce(extra_callbacks, player, fn cb, player -> cb.(player, ticks) end)

    {player, food_to_consume} = apply_food(player)
    max_age = GameConfig.get(:player, :max_age)

    result = player |>
      Player.Bullets.apply_bullets(max_age, bullet_bucketizer, world_state) |>
      Player.MovingFood.apply_moving_foods(moving_food_bucketizer, world_state) |>
      Player.Pickups.apply_pickups(pickups_bucketizer) |>
      increment_age(max_age, ticks) |>
      update_max_size() |>
      update_frost(ticks) |>
      Player.Velocity.update_velocity(ticks) |>
      Move.move(world_state, ticks) |>
      Player.Shoot.shoot_if_shooting(world_state) |>
      update_if_consume(food_to_consume) |>
      Map.update!(:reload_time, &(&1-ticks)) |>
      update_afk_time(ticks) |>
      update_min_radius |>
      check_kill()

    {:noreply, result}
  end

  defp update_max_size(player = %{radius: radius, max_radius: max_radius}) when radius > max_radius do
    Map.put(player, :max_radius, trunc(radius))
  end
  defp update_max_size(player), do: player


  defp update_min_radius(player = %{radius: radius, min_radius: min_radius}) when radius/3 > min_radius do
    Map.put(player, :min_radius, radius/3)
  end
  defp update_min_radius(player), do: player

  defp update_frost(player = %{frost: frost}, ticks) do
    thaw_rate = GameConfig.get(:frost, :thaw_rate)
    Map.put(player, :frost, max(frost-(thaw_rate*ticks), 0))
  end

  defp update_afk_time(player = %{afk_timer: afk_timer}, ticks) do
    Map.put(player, :afk_timer, afk_timer-ticks)
  end

  def action_direct(player, direction, percentage) do
    player |>
      refresh_timer() |>
      Map.put(direction, min(percentage, 1)) |>
      update()
  end

  defp refresh_timer(player) do
    Map.put(player, :afk_timer, GameConfig.get(:player, :afk_timer))
  end

  def action(player, activation, action) do
    player |>
    refresh_timer() |>
    apply_action(activation, action) |>
    update()
  end

  def effect(state, effect) do
    effect.(state) |>
      update()
  end

  def apply_action(player, :down, action), do: Map.put(player, action, 1)
  def apply_action(player, :up,   action), do: Map.put(player, action, 0)

  def restore_state(player) do
    player |>
      Map.put(:sprite, nil) |>
      Map.put(:spritesheet, nil) |>
      Map.put(:background_color, nil) |>
      Map.put(:shoot_callback, &Player.ShootCallbacks.default_shoot/2) |>
      Map.put(:reload_time, 0) |>
      Map.put(:reload, GameConfig.get(:player, :reload)) |>
      Map.put(:friction, GameConfig.get(:player, :friction)) |>
      Map.put(:acceleration,GameConfig.get(:player, :acceleration)) |>
      Map.put(:min_radius, GameConfig.get(:player, :min_radius)) |>
      Map.put(:stall_opacity, 0) |>
      Map.put(:invincible, false) |>
      Map.put(:opacity, 1) |>
      Map.put(:opacity_dx, 0) |>
      Map.put(:bullet_color, nil) |>
      Map.put(:bullet_sprite, nil) |>
      Map.put(:bullet_size_mod, 1) |>
      Map.put(:bullet_damage_mod, 1) |>
      Map.put(:bullet_lifetime_mod, 1) |>
      Map.put(:growth_rate_mod, 1) |>
      Map.put(:bullet_speed_mod, 1) |>
      Map.put(:bullet_end_speed_mod, 1) |>
      Map.put(:bullet_slowdown_duration_mod, 1) |>
      Map.put(:extra_data, nil) |>
      Map.put(:extra_callbacks, []) |>
      Map.put(:hide_aim, false)
  end

  defp kill_player(player) do
    world = Map.get(player, :world)
    die = Map.get(player, :death_callback)
    die.(player)
    ColorGen.free_color(Map.get(player, :color))
    World.remove_player(world, self(), player)
  end

  defp mark_for_death(player) do
    player |>
      Map.put(:death_mark, true) |>
      update()
  end

  def check_kill(player = %{afk_timer: afk_timer}) when afk_timer <= 0 do
    player |> mark_for_death
  end
  def check_kill(player = %{radius: radius, min_radius: min_radius}) when radius < min_radius do
    player |> mark_for_death
  end
  def check_kill(player), do: player

end
