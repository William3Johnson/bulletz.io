defmodule Powerups.Spawner do
  use GenServer

  def init(args) do
   schedule_spawn()
   {:ok, args}
  end

  def start_link(world) do
    GenServer.start_link(__MODULE__, world, name: __MODULE__)
  end

  def handle_info(:spawn, world) do
    %{pickups: pickups, players: players} = Peek.peek(world)
    powerup_num = max(GameConfig.get(:powerups, :min), Enum.count(players)/GameConfig.get(:powerups, :players_per_powerup))
    if Enum.count(pickups) < powerup_num do
      spawn_pickup(world)
    end
    schedule_spawn()
    {:noreply, world}
  end

  defp schedule_spawn() do
    Process.send_after(self(), :spawn, 300)
  end

  def spawn_pickup(world) do
    x = Player.Init.start_x(world)
    y = Player.Init.start_y(world)
    spawn_pickup(x, y, world)
  end
  def spawn_pickup(x, y ,world) do
    powerup = Powerups.get_effect()
    Pickup.new(x: x, y: y, effect: Map.get(powerup, :effect), world: world, name: Map.get(powerup, :name), sprite: Map.get(powerup, :sprite), priority: Map.get(powerup, :priority, 1))
  end

end
