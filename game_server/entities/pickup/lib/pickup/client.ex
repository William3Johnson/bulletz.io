defmodule Pickup.Client do
  def tick(pid, world) do
    GenServer.call(pid, {:tick, world})
  end

  def stop(pid) do
    GenServer.cast(pid, :stop)
  end
end
