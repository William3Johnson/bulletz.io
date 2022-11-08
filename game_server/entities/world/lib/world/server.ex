defmodule World.Server do
  use GenServer
  alias World.Impl, as: Impl

  def init(args) do
    {:ok, args}
   end

  def start_link(broadcast_bullet: broadcast_bullet, broadcast_food: broadcast_food, broadcast_moving_food: broadcast_moving_food, remove_moving_food: remove_moving_food, create_food: create_food, remove_food: remove_food, broadcast_pickup: broadcast_pickup, remove_pickup: remove_pickup) do
    FoodBucketizer.clear()
    GenServer.start_link(__MODULE__, %World{
      broadcast_bullet: broadcast_bullet,
      broadcast_food: broadcast_food,
      broadcast_moving_food: broadcast_moving_food,
      create_food: create_food,
      remove_food: remove_food,
      remove_moving_food: remove_moving_food,
      broadcast_pickup: broadcast_pickup,
      remove_pickup: remove_pickup,
      width: GameConfig.get(:world, :width),
      height: GameConfig.get(:world, :height),
      timestamp: :erlang.system_time(:milli_seconds)
    },
    name: __MODULE__)
  end

  def handle_call({:peek}, _from, state) do
    {:reply, state, state}
  end

  def handle_call({:tick}, _from, state) do
    {:reply, :ok, Impl.tick(state)}
  end

  def handle_cast({:new_player, player}, state) do
    {:noreply, Impl.new_player(state, player)}
  end

  def handle_cast({:remove_player, player, player_state}, state) do
    {:noreply, Impl.remove_player(state, player, player_state)}
  end

  def handle_cast({:new_bullet, bullet, bullet_state}, state) do
    {:noreply, Impl.new_bullet(state, bullet, bullet_state)}
  end

  def handle_cast({:remove_bullet, bullet}, state) do
    {:noreply, Impl.remove_bullet(state, bullet)}
  end

  def handle_cast({:new_food, food}, state) do
    {:noreply, Impl.new_food(state, food)}
  end

  def handle_cast({:remove_food, food}, state) do
    {:noreply, Impl.remove_food(state, food)}
  end

  def handle_cast({:new_pickup, pickup, pickup_state}, state) do
    {:noreply, Impl.new_pickup(state, pickup, pickup_state)}
  end

  def handle_cast({:remove_pickup, pid, id}, state) do
    {:noreply, Impl.remove_pickup(state, pid, id)}
  end

  def handle_cast({:new_moving_food, food}, state) do
    {:noreply, Impl.new_moving_food(state, food)}
  end

  def handle_cast({:remove_moving_food, food, id}, state) do
    {:noreply, Impl.remove_moving_food(state, food, id)}
  end

end
