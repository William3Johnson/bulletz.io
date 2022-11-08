defmodule Pickup.Init do

  def init(args) do
    {:ok, args}
  end

  def start_link(kwargs) do
    state = initial_state(kwargs)
    world = kwargs[:world]
    {:ok, pid} = GenServer.start_link(Pickup.Server, state)
    World.new_pickup(world, pid, state)
    {:ok, pid}
  end

  defp initial_state(kwargs) do
    x = kwargs[:x]
    y = kwargs[:y]
    world = kwargs[:world]
    name  = kwargs[:name]
    sprite = kwargs[:sprite]
    effect = kwargs[:effect]
    priority = kwargs[:priority]

    %Pickup{
      x: x,
      y: y,
      effect: effect,
      world: world,
      id: UUID.uuid1(),
      name: name,
      priority: priority,
      radius: GameConfig.get(:pickup, :radius),
      sprite: sprite,
    }
  end

end
