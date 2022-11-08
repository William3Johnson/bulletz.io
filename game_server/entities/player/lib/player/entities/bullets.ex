defmodule Player.Bullets do
  defp calculate_collision(%{parent_id: id}, %{id: id}), do: false
  defp calculate_collision(bullet, player) do
    Collisions.circle_collision?(bullet, player)
  end

  defp hit_side_effects(bullet, player = %{hit_callback: hit_callback}, world_state) do
    hit_callback.(bullet, player, world_state)
  end

  def hit(%{damage: damage, extra_callbacks: extra_callbacks}, player = %{radius: radius}) do
    result = Enum.reduce(extra_callbacks, player, fn cb, acc -> cb.(acc) end) |>
      Map.put(:radius, radius - damage) |>
      Player.Impl.check_kill()

    if Map.get(result, :death_mark) do
      result |>
        Map.put(:radius, radius) |>
        Player.Impl.update()
    else
      result |>
        Player.Impl.update()
    end
  end

  defp apply_hits(bullet, player) do
    hit(bullet, player)
  end

  defp apply_collisions(bullets, player, world_state) do
    Enum.map(bullets, fn {_pid, bullet} -> hit_side_effects(bullet, player, world_state) end)
    Enum.map(bullets, fn {pid, _state} -> World.remove_bullet(World.Server, pid) end)
    Enum.map(bullets, fn {pid, _state} -> Bullet.stop(pid) end)

    Enum.map(bullets, fn {_pid, state} -> state end) |>
      Enum.reduce(player, &apply_hits/2)
  end

  def apply_bullets(player = %{invincible: true}, _1, _2, _world_state), do: player
  def apply_bullets(player = %{age: age}, max_age, _, _world_state) when age < max_age do player end
  def apply_bullets(player, _, bullet_bucketizer, world_state) do
    Bucketizer.relevant_buckets(bullet_bucketizer, player) |>
      Enum.map(fn pid -> {pid, Peek.peek(pid)} end) |>
      Enum.filter(fn {_, state} -> (calculate_collision(state, player)) end) |>
      apply_collisions(player, world_state)
  end
end
