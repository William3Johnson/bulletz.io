defmodule Highscores.Impl do

  def update_scores(scores, player) do
    max_scores = Application.get_env(:highscores, :max_radius) || 10

    min_score = Enum.reduce(scores, 0, &find_min/2)

    scores = [encode_player_to_score(player) | scores] |>
      Enum.sort_by(&score_comparator/1) |>
      Enum.take(max_scores) |>
        apply_ranks()

    {Map.get(player, :max_radius) > min_score, scores}
  end

  defp find_min(acc, %Highscores.Model.Score{score: score}) when score < acc do
    score
  end
  defp find_min(acc, _), do: acc

  defp apply_ranks(scores) do
    scores |>
      Enum.with_index(1) |>
      Enum.map(fn {score, index} -> Map.put(score, :rank, index) end)
  end

  defp score_comparator(score) do
    -Map.get(score, :score, 0)
  end

  defp encode_player_to_score(player) do
    %Highscores.Model.Score{name: Map.get(player, :name), score: Map.get(player, :max_radius), rank: -1}
  end
end
