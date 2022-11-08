defmodule MovingFood.Client do

  def tick(pid, world_state) do
    GenServer.call(pid, {:tick, world_state})
  end

  def stop(pid) do
    GenServer.cast(pid, :stop)
  end
end
