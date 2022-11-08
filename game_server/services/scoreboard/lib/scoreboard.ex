defmodule Scoreboard do
  defdelegate scoreboard, to: Scoreboard.Client
end
