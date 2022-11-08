defmodule MovingFood.Init do

  def init(state = %{world: world}) do
    World.new_moving_food(world, self())
    {:ok, state}
  end

  def start_link(bullet, player, world_state) do
    GenServer.start_link(MovingFood.Server, initial_state(bullet, player, world_state))
  end

  defp curry_moving_food_effect(moving_food) do
    fn player -> MovingFood.Impl.effect(player, moving_food) end
  end

  defp initial_state(bullet = %{damage: damage}, player = %{world: world, radius: parent_rad, color: color, id: parent_id}, world_state) do
    size_mod = Map.get(bullet, :size_mod, 1)
    food_size = min(damage, parent_rad)

    speed = 1 + :rand.uniform*GameConfig.get(:moving_food, :speed)
    slowdown_duration = GameConfig.get(:moving_food, :slowdown_duration)
    lifetime = GameConfig.get(:moving_food, :lifetime)

    angle = :rand.uniform() * :math.pi * 2
    vx = :math.sin(angle) * speed
    vy = :math.cos(angle) * speed

    %{x: x, y: y} = MovingFood.Transformations.transform_player(player, food_size, world_state, angle)

    %MovingFood{
      x: x,
      y: y,
      velocity_x:  vx,
      velocity_y:  vy,
      velocity_x_prev:  vx,
      velocity_y_prev:  vy,
      speed: speed,
      age: 0,
      vx_slowdown: vx/slowdown_duration,
      vy_slowdown: vy/slowdown_duration,
      slowdown_duration: slowdown_duration,
      lifetime: lifetime,
      effect: curry_moving_food_effect(%{parent_radius: parent_rad, radius: food_size}),
      world: world,
      parent_id: parent_id,
      parent_radius: parent_rad,
      id: UUID.uuid1(),
      radius: food_size*GameConfig.get(:moving_food, :size_mod)*size_mod,
      timestamp: :erlang.system_time(:milli_seconds),
      color: color
    }
  end

end
