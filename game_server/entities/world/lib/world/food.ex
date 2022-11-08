defmodule World.Food do

  defp start_x(%{width: world_width}, food_radius) do
    range = world_width - 2*food_radius
    food_radius + :rand.uniform()*range
  end
  defp start_y(%{height: world_height}, food_radius) do
    range = world_height - 2*food_radius
    food_radius+ :rand.uniform()*range
  end

  def generate_enough(num_food, max_food, world, _create_food) when num_food >= max_food do
    world
  end
  def generate_enough(num_food, max_food, world, create_food) do
    radius = Enum.random(GameConfig.get(:food, :radius_range))
    {:ok, new_food} = create_food.(x: start_x(world, radius), y: start_y(world, radius), radius: radius, world: self())
    generate_enough(num_food+1, max_food, World.Impl.new_food(world, new_food), create_food)
  end

  def spawn_food(world = %{food: food, moving_food: moving_food, width: width, height: height, create_food: create_food}) do
    max_food = GameConfig.get(:food, :base_food) + width*height/GameConfig.get(:food, :area_per_food)
    num_food = Enum.count(food) + Enum.count(moving_food)

    generate_enough(num_food, trunc(max_food), world, create_food)
  end

end
