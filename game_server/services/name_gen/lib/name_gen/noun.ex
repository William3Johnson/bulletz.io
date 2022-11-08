defmodule NameGen.Noun do

  @nouns  [
    "cat",
    "dog",
    "yeti",
    "fish",
    "bear",
    "beggar",
    "puppy",
    "colt",
    "filly",
    "herd",
    "pig",
    "cow",
    "rooster",
    "kitten",
    "glider",
    "nymph",
    "croc",
    "boar",
    "seal",
    "shark",
    "joey",
    "kangaroo"
  ]

  def nouns() do
    @nouns
  end

  def random_noun() do
    Enum.random(nouns)
  end
end
