defmodule MovingFood.Impl do

  defp decrement_lifetime(food, ticks) do
    Map.update!(food, :lifetime, &(&1-ticks)) |>
      Map.update!(:age, &(&1+ticks))
  end

  def tick(food, world_state) do
    {ticks, food} = Ticks.elapsed_ticks(food)

    Move.move(food, world_state, ticks) |>
       decrement_lifetime(ticks) |>
       stop_if_needed(world_state, ticks)
  end

  defp stop_if_needed(state = %{lifetime: l}, _, ticks) when l - ticks <= 0 do
    consume(state)
  end
  defp stop_if_needed( state = %{x: x, y: y}, %{width: world_width, height: world_height}, _ticks) when x > world_width or y > world_height do
    consume(state)
  end
  defp stop_if_needed(state, _world, _ticks) do
    {:reply, :ok, state}
  end

  defp consume(state = %{world: world, id: id}) do
    World.remove_moving_food(world, self(), id)
    {:stop, :normal, :ok, state}
  end

  def effect(player = %{radius: radius}, %{parent_radius: parent_rad, radius: food_radius}) when parent_rad < radius do
    moving_food_value_percent = GameConfig.get(:moving_food, :value_mod)
    times_bigger = (radius/parent_rad)

    value_mod = moving_food_value_percent/(times_bigger)

    Map.put(player, :radius, radius + food_radius*value_mod)
  end
  def effect(player = %{radius: radius}, %{radius: food_radius}) do
    moving_food_value_percent = GameConfig.get(:moving_food, :value_mod)
    Map.put(player, :radius, radius + food_radius*moving_food_value_percent)
  end

end
