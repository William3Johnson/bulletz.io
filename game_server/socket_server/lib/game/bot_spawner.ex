defmodule SocketServer.BotSpawner do
  use GenServer
  def init(args) do
    schedule_tick()
    {:ok, args}
   end

  def start_link() do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def handle_info(:tick, _) do
    schedule_tick()
    handle_bot_spawns()
    {:noreply, :ok}
  end

  # Pretty bad code I just wanted to see how this would work out.
  defp handle_bot_spawns() do
    num_players = Peek.peek(SocketServer.Connector.world()) |> Map.get(:players) |> length()
    if num_players < GameConfig.get(:bot, :minimum_bots) do
      new_bot()
    else
      probability_spawn_bot(num_players)
    end
  end

  defp probability_spawn_bot(num_players) do
    bot_rate = num_players-GameConfig.get(:bot, :minimum_bots)
    bot_rate = max(bot_rate, 1)+1
    probability = bot_rate*bot_rate
    result=trunc(:rand.uniform * probability)
    if result == 1 and num_players < GameConfig.get(:bot, :max_bots) do
    #  new_bot()
    end
  end

  defp schedule_tick() do
    Process.send_after(self(), :tick, 250)
  end

  def new_bot() do
    Bot.new(&SocketServer.Connector.new_bot_player/1)
  end

end
