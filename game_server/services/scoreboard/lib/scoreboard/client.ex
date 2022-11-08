defmodule Scoreboard.Client do
  def scoreboard do
    GenServer.call(Scoreboard.Server, {:scoreboard})
  end
end
