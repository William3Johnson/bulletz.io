defmodule Player.Pickups do
  defp calculate_collision(%{parent_id: id}, %{id: id}), do: false
  defp calculate_collision(pickup, player) do
    Collisions.circle_collision?(pickup, player)
  end

  defp apply_effects(%{effect: effect}, player) do
    Player.Impl.effect(player, effect)
  end

  defp apply_collisions(pickups, player) do
    Enum.map(pickups, fn {pid, %{id: id}} -> World.remove_pickup(World.Server, pid, id) end)
    Enum.map(pickups, fn {pid, _state} -> Pickup.stop(pid) end)

    Enum.map(pickups, fn {_pid, state} -> state end) |>
      Enum.reduce(player, &apply_effects/2)
  end

  def apply_pickups(player, pickup_bucketizer) do
    Bucketizer.relevant_buckets(pickup_bucketizer, player) |>
      Enum.map(fn pid -> {pid, Peek.peek(pid)} end) |>
      Enum.filter(fn {_, state} -> (calculate_collision(state, player)) end) |>
      apply_collisions(player)
  end
end
