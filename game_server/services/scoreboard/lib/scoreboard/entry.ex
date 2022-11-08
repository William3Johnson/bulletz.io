defmodule Scoreboard.Entry do

  @derive {
    Poison.Encoder,
    only: [
      :color,
      :name,
      :score
    ]
  }
  defstruct [
    id:    0,
    name:  "",
    color: "0x000000",
    score: 0
  ]

  def scoreboard_entry_comparitor(%Scoreboard.Entry{score: score}, %Scoreboard.Entry{score: score2}) do
      score > score2
  end

end
