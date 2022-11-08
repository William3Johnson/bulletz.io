defmodule Pickup.Impl do

  def tick(pickup, world_state) do
    remove_if_needed(pickup, world_state)
  end

  defp remove_if_needed(state = %{id: id, x: x, y: y, radius: radius}, %{width: width, height: height}) when x > width-radius or x < radius or y > height-radius or y < radius do
     World.remove_pickup(World.Server, self(), id)
    {:stop, :normal, :ok, state}
  end
  defp remove_if_needed(state, _world_state) do
    {:reply, :ok, state}
  end
end
