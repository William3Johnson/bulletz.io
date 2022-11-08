defmodule Highscores.Client do
  def log_score(player) do
    if Application.get_env(:highscores, :enabled, false) do
      GenServer.cast(Highscores.Server, {:score, player})
    else
      :ok
    end
  end
end
