defmodule Bot.Impl do

  def new_player(create_player, Bot.Simple) do
    {:ok, pid} = create_player.(name: NameGen.random_bot(), mobile: false)
    pid
  end
  def new_player(create_player, _backend) do
    {:ok, pid} = create_player.(name: NameGen.special(), mobile: false)
    pid
  end

  def random_backend() do
    Enum.random([Bot.Simple, Bot.Simple, Bot.Simple, Bot.Simple, Bot.Simple, Bot.Simple, Bot.Medium])
  end

  def shoot(state = %{player: player_pid, backend: backend}, player = %{world: world}) do
    %{players: players} = Peek.peek(world)
    target = apply(backend, :find_target, [player, players])
    if target != nil, do: Player.shoot(player_pid, target)
    {:noreply, state}
  end

  def check_world_boundaries(state = %{player: player}, %{radius: radius, x: x, y: y, world: world}) do
    %{width: world_width, height: world_height} = Peek.peek(world)
    if x >= world_width - radius do
      Player.action_direct(player, :left, :rand.uniform)
      Player.action_direct(player, :right, 0)
    end
    if x <= radius do
      Player.action_direct(player, :left, 0)
      Player.action_direct(player, :right, :rand.uniform)
    end
    if(y >= world_height - radius) do
      Player.action_direct(player, :up, :rand.uniform)
      Player.action_direct(player, :down, 0)
    end
    if y <= radius do
      Player.action_direct(player, :up, 0)
      Player.action_direct(player, :down, :rand.uniform)
    end
    {:noreply, state}
  end

  def stop(state = %{player: player, backend: backend}, _player_state) do
    if apply(backend, :should_stop, []) do
      Player.action_direct(player, :up, 0)
      Player.action_direct(player, :down, 0)
      Player.action_direct(player, :left, 0)
      Player.action_direct(player, :right, 0)
    end
    {:noreply, state}
  end

  def update_movement(state = %{player: player, backend: backend}, player_state = %{world: world}) do
    %{up: up, down: down, left: left, right: right} = apply(backend, :movements, [player_state, world])
    Player.action_direct(player, :up, up)
    Player.action_direct(player, :down, down)
    Player.action_direct(player, :left, left)
    Player.action_direct(player, :right, right)
    {:noreply, state}
  end

end
