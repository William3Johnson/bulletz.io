defmodule Food.Impl do

  def consume_food(food, player) do
    if remove_food(food) do
      food_effect(player, food)
    else
      player
    end
  end

  defp ok?({:ok, :cancel}), do: true
  defp ok?({:error, _}), do: false

  def remove_food(food = %{world: world, tref: tref}) do
    response = :timer.cancel(tref)
    World.remove_food(world, food)
    :ok = FoodBucketizer.remove_food(food)
    ok?(response)
  end

  defp inner_food_effect(player =  %{radius: radius, growth_rate_mod: growth_rate_mod}, food_radius, linear_portion) do
    times_bigger = radius/GameConfig.get(:player, :food_falloff_size)

    growth_factor = min(1/(times_bigger*times_bigger), 1)
    growth_factor = ((growth_factor*(1-linear_portion)) +  linear_portion) * growth_rate_mod
    growth_factor = growth_factor*GameConfig.get(:food, :food_value_mod)
    Map.update!(player, :radius, &(&1 + (growth_factor*food_radius)))
  end

  def food_effect(player = %{radius: radius}, %{radius: food_radius}) when radius < 125 do
    inner_food_effect(player, food_radius, 1)
  end
  def food_effect(player = %{radius: radius}, %{radius: food_radius}) when radius < 250 do
    inner_food_effect(player, food_radius, 0.9)
  end
  def food_effect(player = %{radius: radius}, %{radius: food_radius}) when radius < 500 do
    inner_food_effect(player, food_radius, 0.7)
  end
  def food_effect(player = %{radius: radius}, %{radius: food_radius}) when radius < 850 do
    inner_food_effect(player, food_radius, 0.5)
  end
  def food_effect(player = %{radius: radius}, %{radius: food_radius}) when radius < 1100 do
    inner_food_effect(player, food_radius, 0.25)
  end
  def food_effect(player = %{radius: radius}, %{radius: food_radius}) when radius < 1300 do
    inner_food_effect(player, food_radius, 0.15)
  end
  def food_effect(player = %{radius: radius}, %{radius: food_radius}) when radius < 1600 do
    inner_food_effect(player, food_radius, 0.05)
  end
  def food_effect(player, %{radius: food_radius}) do
    inner_food_effect(player, food_radius, 0)
  end

  def new(kwargs) do
    state = initial_state(kwargs)
    FoodBucketizer.add_food(state)
    {:ok, state}
  end

  def initial_state(kwargs) do
    x = kwargs[:x]
    y = kwargs[:y]
    radius = kwargs[:radius]
    world = kwargs[:world]
    color = ColorGen.random_color()

    state = %Food{
      x: x,
      y: y,
      world: world,
      id: UUID.uuid1(),
      radius: radius,
      color: color
    }
    {:ok, tref} = :timer.apply_after(GameConfig.get(:food, :lifetime) * GameConfig.get(:world, :interval), Food.Impl, :remove_food, [state])
    Map.put(state, :tref, tref)
  end

end
