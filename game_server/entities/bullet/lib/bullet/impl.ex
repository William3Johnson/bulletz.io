defmodule Bullet.Impl do

  defp decrement_lifetime(state, ticks) do
    state |>
      Map.update!(:lifetime, &(&1 - ticks)) |>
      Map.update!(:age, &(&1+ticks))
  end

  defp update_bullet(bullet, world_state) do
    {ticks, bullet} = Ticks.elapsed_ticks(bullet)

    bullet |>
      Move.move(world_state, ticks) |>
      decrement_lifetime(ticks)
  end

  def tick(state = %{lifetime: l}, _world_state) when l <= 0 do
    die(state)
  end
  def tick(state, world_state) do
    {:reply, :ok, update_bullet(state, world_state)}
  end

  def die(state = %{world: world}) do
    World.remove_bullet(world, self())
    {:stop, :normal, :ok, state}
  end
end
