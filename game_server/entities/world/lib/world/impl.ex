defmodule World.Impl do

  def new_player(state = %{players: players}, player) do
    Map.put(state, :players, [player | players])
  end
  def remove_player(state = %{players: players},  player, player_state = %{radius: radius}) do
    players = Enum.filter(players, fn p -> p != player end)
    spawn_food_for_player_kill(Map.put(player_state,:radius, radius), state)
    Map.put(state, :players, players)
  end

  defp spawn_food_for_player_kill(%{radius: radius}, _world_state) when radius <= 0 do
    nil
  end
  defp spawn_food_for_player_kill(player = %{radius: radius}, world_state) do
    size = radius
    MovingFood.for_player_death(size, player, world_state)
    spawn_food_for_player_kill(Map.put(player, :radius, radius-size), world_state)
  end

  def new_bullet(state = %{bullets: bullets, broadcast_bullet: broadcast_bullet}, bullet, bullet_state) do
     broadcast_bullet.(bullet_state)
     Map.put(state, :bullets, [bullet | bullets])
  end
  def remove_bullet(state = %{bullets: bullets}, bullet) do
    bullets = Enum.filter(bullets, fn b -> b != bullet end)
    Map.put(state, :bullets, bullets)
  end

  def new_food(state = %{food: food, broadcast_food: broadcast_food}, new_food) do
     broadcast_food.(new_food)
     Map.put(state, :food, [new_food | food])
  end
  def remove_food(state = %{food: food, remove_food: remove_food}, %{id: id}) do
    food = Enum.filter(food, fn
      %{id: ^id} -> false
      _ -> true
       end)
    remove_food.(id)
    Map.put(state, :food, food)
  end

  def new_pickup(state = %{pickups: pickups, broadcast_pickup: broadcast_pickup}, new_pickup, pickup_state) do
     broadcast_pickup.(pickup_state)
     Map.put(state, :pickups, [new_pickup | pickups])
  end
  def remove_pickup(state = %{pickups: pickups, remove_pickup: remove_pickup}, pid, id) do
    pickups = Enum.filter(pickups, fn
      ^pid -> false
      _ -> true
    end) |> Enum.filter(&Process.alive?/1)
    remove_pickup.(id)
    Map.put(state, :pickups, pickups)
  end


  def new_moving_food(state = %{moving_food: food, broadcast_moving_food: broadcast_moving_food}, new_food) do
     broadcast_moving_food.(Peek.peek(new_food))
     Map.put(state, :moving_food, [new_food | food])
  end
  def remove_moving_food(state = %{moving_food: food, remove_moving_food: remove_food}, removed_food, id) do
    food = Enum.filter(food, fn b -> b != removed_food end)
    remove_food.(id)
    Map.put(state, :moving_food, food)
  end
  def remove_moving_food(state = %{moving_food: food}, removed_food) do
    food = Enum.filter(food, fn b -> b != removed_food end)
    Map.put(state, :moving_food, food)
  end

  defp update_width_height(state = %{width: width, height: height}, target_size, dx) when width*height < target_size do
    target_side = :math.sqrt(target_size)
    updated_width = min(target_side, width + dx)
    updated_height = min(target_side, height + dx)

    state |>
      Map.put(:width, updated_width) |>
      Map.put(:height, updated_height)
  end
  defp update_width_height(state = %{width: width, height: height}, target_size, dx) when width*height > target_size do
    target_side = :math.sqrt(target_size)
    updated_width = max(target_side, width - dx)
    updated_height = max(target_side, height - dx)

    state |>
      Map.put(:width, updated_width) |>
      Map.put(:height, updated_height)
  end
  defp update_width_height(state, _target_size, _dx) do
    state
  end

  defp filter_dead_process(processes) do
    Enum.filter(processes, &Process.alive?/1)
  end

  defp remove_dead(state) do
    state |>
      Map.update!(:players, &filter_dead_process/1) |>
      Map.update!(:bullets, &filter_dead_process/1) |>
      Map.update!(:moving_food, &filter_dead_process/1)
  end

  def tick(state) do
    {ticks, state} = Ticks.elapsed_ticks(state)
    state = %{players: players} = remove_dead(state)
    area_per_player = GameConfig.get(:world, :area_per_player)
    dx = GameConfig.get(:world, :dx)*ticks
    target_size = GameConfig.get(:world, :width)*GameConfig.get(:world, :height) + length(players)*area_per_player

    update_width_height(state, target_size, dx) |>
      World.Food.spawn_food()
  end

end
