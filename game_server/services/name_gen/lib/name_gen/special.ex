defmodule NameGen.Special do

  @names  [
    "brocollini",
    "Don't kill me pls",
    "Gunthor the gr8",
    "719",
    "l33t",
    "y33t",
    "Y33t sucks lol",
    "team?",
    "random noob",
    "Luke's monstrocity",
    "Die noobs",
    "slandor",
    "pink9870",
    "funkish101",
    "puppet pals",
    "liite",
    "ook ape",
    "ook monki",
    "Fenkenstrain",
    "07scape",
    "20 November"
  ]

  def random() do
    Enum.random(@names)
  end
end
