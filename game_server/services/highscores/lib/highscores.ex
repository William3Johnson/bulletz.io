defmodule Highscores do
  defdelegate log_score(player), to: Highscores.Client
end
