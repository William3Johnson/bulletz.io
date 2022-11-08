defmodule Player.Init do

  def init(state) do
    {:ok, %{state | pid: self()}}
  end

  def start_x(world) do
    player_radius = GameConfig.get(:player, :radius)
    world_width   = Peek.peek(world) |> Map.get(:width)
    range = world_width - 2*player_radius
    player_radius + :rand.uniform()*range
  end
  def start_y(world) do
    player_radius = GameConfig.get(:player, :radius)
    world_height  = Peek.peek(world) |> Map.get(:height)
    range = world_height - 2*player_radius
    player_radius+ :rand.uniform()*range
  end

  def start_link(world: world, name: name, update_callback: update_callback, death_callback: death_callback, hit_callback: hit_callback, mobile: mobile) do
    state = get_initial_state(world, name, update_callback, death_callback, hit_callback, mobile)
    {:ok, pid} = GenServer.start_link(Player.Server, state)
    World.new_player(world, pid)
    update_callback.(state)
    {:ok, pid}
  end

  def get_initial_state(world, name, update_callback, death_callback, hit_callback, mobile) do
    color = ColorGen.next_color()
    %Player{
      world: world,
      name: name,
      reload: GameConfig.get(:player, :reload),
      update_callback: update_callback,
      death_callback:  death_callback,
      shoot_callback:  &Player.ShootCallbacks.default_shoot/2,
      hit_callback: hit_callback,
      x: start_x(world),
      y: start_y(world),
      friction:  GameConfig.get(:player, :friction),
      acceleration: GameConfig.get(:player, :acceleration),
      radius: GameConfig.get(:player, :radius),
      starting_radius: GameConfig.get(:player, :radius),
      min_radius: GameConfig.get(:player, :min_radius),
      afk_timer: GameConfig.get(:player, :afk_timer),
      timestamp: :erlang.system_time(:millisecond),
      death_mark_timer: GameConfig.get(:player, :death_mark_timer),
      id: UUID.uuid1(),
      color: color,
      up: 0,
      left: 0,
      right: 0,
      down: 0,
      mobile: mobile,
    }
  end
end
