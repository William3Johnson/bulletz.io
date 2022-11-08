defmodule MovingFood.Server do
   use GenServer

   defdelegate start_link(bullet, player, world_state), to: MovingFood.Init
   defdelegate init(args),         to: MovingFood.Init

   def handle_call({:peek}, _from, state) do
     {:reply, state, state}
   end

   def handle_call({:tick, world_state}, _from, state) do
     MovingFood.Impl.tick(state, world_state)
   end

   def handle_cast(:stop, state) do
     {:stop, :normal, state}
   end
   
end
