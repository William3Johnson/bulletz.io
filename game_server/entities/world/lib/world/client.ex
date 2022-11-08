defmodule World.Client do

    def new_player(pid, player) do
      GenServer.cast(pid, {:new_player, player})
    end

    def remove_player(pid, player, player_state) do
      GenServer.cast(pid, {:remove_player, player, player_state})
    end

    def new_bullet(pid, bullet, bullet_state) do
      GenServer.cast(pid, {:new_bullet, bullet, bullet_state})
    end

    def remove_bullet(pid, bullet) do
      GenServer.cast(pid, {:remove_bullet, bullet})
    end

    def tick(pid) do
      GenServer.call(pid, {:tick})
    end

    def new_food(pid, food) do
      GenServer.cast(pid, {:new_food, food})
    end

    def remove_food(pid, food) do
      GenServer.cast(pid, {:remove_food, food})
    end

    def new_pickup(pid, pickup, pickup_state) do
      GenServer.cast(pid, {:new_pickup, pickup, pickup_state})
    end

    def remove_pickup(pid, pickup_pid, id) do
      GenServer.cast(pid, {:remove_pickup, pickup_pid, id})
    end

    def new_moving_food(pid, food) do
      GenServer.cast(pid, {:new_moving_food, food})
    end

    def remove_moving_food(pid, food, id) do
      GenServer.cast(pid, {:remove_moving_food, food, id})
    end

    def remove_moving_food(pid, food) do
      GenServer.cast(pid, {:remove_moving_food, food})
    end
end
