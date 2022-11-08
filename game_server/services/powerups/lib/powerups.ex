defmodule Powerups do

  def start(_opts, _type) do
    Agent.start(fn -> GameConfig.get(:powerups, :powers) end, name: Powerups.Agent)
  end

  def get_effect() do
    Enum.random(Powerups.Agent.effects_list())
  end

end
