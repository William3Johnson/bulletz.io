defmodule Ticker.Impl do
  def safe_apply(func, args) do
    try do
      apply(func, args)
    catch
      _failure_type, _reason -> nil
    end
  end

  defp extract_pid({:ok, task_pid}) do
    task_pid
  end
  defp extract_pid(error) do
    IO.inspect error
    nil
  end

  defp wait_for(task) do
    case Task.yield(task, 5000) || Task.shutdown(task) do
      {:ok, result} ->
        result
      _ ->
        nil
    end
  end

  defp alive?(nil), do: false
  defp alive?(pid) do
    Process.alive?(pid)
  end

  defp living(list) do
    Enum.filter(list, &alive?/1)
  end

  defp not_nil_state?({_pid, nil}), do: false
  defp not_nil_state?(_), do: true

  defp package(pids) do
    Enum.map(pids, fn pid -> {pid, Peek.peek(pid)} end) |>
      Enum.filter(&not_nil_state?/1)
  end

  def tick(world) do
    :ok = World.tick(world)
    %{width: width, height: height, players: players, pickups: pickups, bullets: bullets, moving_food: moving_food} = Peek.peek(world)
    # TODO(lukewood): ok so here's the deal
    # estimated bullets: 5 * players
    # O(bullets_tick)=bullets*players
    #                => 5*p^2
    # estimated moving_food: players
    # O(moving_food_tick) => moving_food*players
    #                     => p^2

    # Bucketize players:  O(players) (theoretically this might have to be p*log(p))
    # tick with bucketized players:
    # *if copying required* -> same :(

    # if copying of player table can be avoided (I think the right way to do this is to start a process that dishes out the players to the processes as needed)
    # this might cause a bottleneck though but it's possibly a good approach - we shall see.

    bullets_packaged = package(bullets)
    moving_food_packaged = package(moving_food)
    pickups_packaged = package(pickups)

    Bucketizer.update(BulletBucketizer, bullets_packaged)
    Bucketizer.update(MovingFoodBucketizer, moving_food_packaged)
    Bucketizer.update(PickupBucketizer, pickups_packaged)

    wait_for =
      Enum.map(living(players), fn player ->
        Task.start(__MODULE__, :safe_apply, [&Player.tick/2, [player, %{width: width, height: height, bullet_bucketizer: BulletBucketizer, moving_food_bucketizer: MovingFoodBucketizer, pickups_bucketizer: PickupBucketizer}]])
      end) ++
      Enum.map(living(bullets), fn bullet ->
        Task.start(__MODULE__, :safe_apply, [&Bullet.tick/2, [bullet, %{width: width, height: height}]])
       end) ++
      Enum.map(living(moving_food), fn m_food ->
        Task.start(__MODULE__, :safe_apply, [&MovingFood.tick/2, [m_food, %{width: width, height: height}]])
      end) ++
      Enum.map(living(pickups), fn pickup ->
        Task.start(__MODULE__, :safe_apply, [&Pickup.tick/2, [pickup, %{width: width, height: height}]])
      end)

    wait_for |>
      Enum.map(&extract_pid/1) |>
      Enum.filter(&(&1 == nil)) |>
      Enum.each(&wait_for/1)

    {:noreply, nil}
  end
end
