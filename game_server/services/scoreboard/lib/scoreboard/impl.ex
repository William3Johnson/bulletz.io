defmodule Scoreboard.Impl do

  defp validate_result(result = {:safe, _}), do: Phoenix.HTML.safe_to_string(result)
  defp validate_result(_),             do: "unsafe_name"

  defp sanitize_name(name) do
    Phoenix.HTML.html_escape(name) |>
    validate_result()
  end

  defp sanitize_entry(player = %Scoreboard.Entry{name: name}) do
    player |>
      Map.put(:name, sanitize_name(name))
  end

  defp not_nil(nil), do: false
  defp not_nil(_), do: true

  defp player_to_entry(nil), do: nil
  defp player_to_entry(%{id: id, name: name, color: color, radius: radius}) do
    %Scoreboard.Entry{
      id: id,
      name: name,
      color: color,
      score: radius
    }
  end

  defp fetch_scores(nil), do: []
  defp fetch_scores(%{players: players}) do
    players |>
      Enum.filter(&Process.alive?/1) |>
      Enum.map(&Peek.peek/1) |>
      Enum.filter(&not_nil/1) |>
      Enum.map(&player_to_entry/1)
  end

  def update_scoreboard(state = %{world: world}) do
    result = fetch_scores(Peek.peek(world)) |>
      Enum.sort(&Scoreboard.Entry.scoreboard_entry_comparitor/2) |>
      Enum.take(5)  |>
      Enum.map(&sanitize_entry/1)
    %{state | scoreboard: result}
  end

end
