defmodule Powerups.Agent do

  def effects_list() do
    Agent.get(__MODULE__, fn state -> Enum.shuffle(state) end)
  end
end
