defmodule Bucketizer.Client do
  def update(pid, entity_list) do
    GenServer.cast(pid, {:update, entity_list})
  end
  def relevant_buckets(pid, arg) do
    GenServer.call(pid, {:relevant_buckets, arg})
  end
end
