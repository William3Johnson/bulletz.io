defmodule NameGen.Adjective do

  @adjectives  [
    "small",
    "big",
    "fast",
    "wild",
    "mean",
    "angry",
    "tangy",
    "jolly",
    "eager",
    "kind",
    "fit",
    "lively",
    "polite",
    "proud",
    "silly",
    "zealous",
    "witty",
    "huge",
    "little",
    "puny",
    "scary",
    "silly"
  ]

  def adjectives() do
    @adjectives
  end

  def random_adjective do
    Enum.random(adjectives())
  end

end
