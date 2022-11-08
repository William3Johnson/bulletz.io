defmodule Player.MovingFood do
  defp calculate_collision(%{parent_id: id}, %{id: id}), do: false
  defp calculate_collision(moving_food, player) do
    Collisions.circle_collision?(moving_food, player)
  end

  defp apply_effects(%{effect: effect}, player) do
    Player.Impl.effect(player, effect)
  end

  defp apply_collisions(moving_foods, player) do
    Enum.map(moving_foods, fn {pid, %{id: id}} -> World.remove_moving_food(World.Server, pid, id) end)
    Enum.map(moving_foods, fn {pid, _state} -> MovingFood.stop(pid) end)

    Enum.map(moving_foods, fn {_pid, state} -> state end) |>
      Enum.reduce(player, &apply_effects/2)
  end

  def apply_moving_foods(player, moving_food_bucketizer, world_state) do
    Bucketizer.relevant_buckets(moving_food_bucketizer, player) |>
      Enum.map(fn pid -> {pid, Peek.peek(pid)} end) |>
      Enum.filter(fn {_, state} -> (calculate_collision(state, player)) end) |>
      apply_collisions(player)
  end
end
