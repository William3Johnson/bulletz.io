defmodule Bucketizer.Server do
  use GenServer

  def init(args) do
    {:ok, args}
  end

  def start_link(name) do
    GenServer.start_link(__MODULE__,{100, %{}}, name: name)
  end

  def handle_cast({:update, arg}, _) do
    {:noreply, Bucketizer.Update.calculate_buckets(arg)}
  end

  def handle_call({:relevant_buckets, arg}, _from, state = {buckets, bucket_size}) do
    {:reply, Bucketizer.Relevant.relevant_buckets(buckets, arg, bucket_size), state}
  end

end
