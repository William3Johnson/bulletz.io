defmodule SocketServer.Connector do
  use Supervisor

  def start_link() do
    Supervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    children = [
      worker(World.Server, [world_args()], restart: :permanent),
      worker(Ticker, [World.Server], restart: :permanent),
      worker(Bucketizer.Server, [BulletBucketizer], restart: :permanent, id: BulletBucketizer),
      worker(Bucketizer.Server, [MovingFoodBucketizer], restart: :permanent, id: MovingFoodBucketizer),
      worker(Bucketizer.Server, [PickupBucketizer], restart: :permanent, id: PickupBucketizer),
      worker(Powerups.Spawner, [World.Server], restart: :permanent),
      worker(Scoreboard.Server, [World.Server, &SocketServer.Updates.broadcast_scoreboard/1], restart: :permanent),
      worker(SocketServer.BotSpawner, [], restart: :permanent)
    ]

    children = if Application.get_env(:highscores, :enabled) do
      children ++ [
        supervisor(Highscores.Supervisor, restart: :permanent)
      ]
    else
      children
    end

    opts = [strategy: :rest_for_one]
    supervise(children, opts)
  end

  def world_args() do
    [
      broadcast_bullet: &SocketServer.Updates.broadcast_bullet/1,
      broadcast_food: &SocketServer.Updates.broadcast_food/1,
      broadcast_moving_food: &SocketServer.Updates.broadcast_moving_food/1,
      remove_moving_food: &SocketServer.Updates.broadcast_remove_moving_food/1,
      create_food:  &Food.new/1,
      remove_food: &SocketServer.Updates.broadcast_remove_food/1,
      broadcast_pickup: &SocketServer.Updates.broadcast_pickup/1,
      remove_pickup: &SocketServer.Updates.broadcast_remove_pickup/1
    ]
  end

  def world() do
    World.Server
  end

  def state do
    Peek.peek(world()) |>
      Map.put(:world, Peek.peek(world()))
  end

  def new_bot_player(name: name, mobile: mobile) do
    %{ effect: function } = Powerups.get_effect()
    {:ok, pid} = new_player(name: name, mobile: mobile)
    Player.effect(pid, function)
    {:ok, pid}
  end

  def new_player(name: name, mobile: mobile) do
    Player.new(
      world: world(),
      name: String.slice(name, 0..16),
      update_callback: &SocketServer.Updates.broadcast_player/1,
      death_callback:  &kill_player/1,
      hit_callback:    &hit_callback/3,
      mobile: mobile
    )
  end

  defp hit_callback(bullet, player, world_state) do
    MovingFood.from_hit(bullet, player, world_state)
    SocketServer.Updates.broadcast_remove_bullet(bullet)
  end

  defp kill_player(player = %{id: player_id}) do
    Highscores.log_score(player)
    SocketServer.Updates.broadcast_kill(player_id)
  end

end
