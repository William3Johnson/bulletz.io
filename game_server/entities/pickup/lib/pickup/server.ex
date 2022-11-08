defmodule Pickup.Server do
   use GenServer

   defdelegate start_link(kwargs), to: Pickup.Init
   defdelegate init(args),         to: Pickup.Init

   def handle_call({:peek}, _from, state) do
     {:reply, state, state}
   end

    def handle_call({:tick, world}, _from, state) do
      Pickup.Impl.tick(state, world)
    end

    def handle_cast(:stop, state) do
      {:stop, :normal, state}
    end
end
