defmodule NameGen do
  def random() do
    NameGen.Adjective.random_adjective()<>"-"<>NameGen.Noun.random_noun()
  end

  def random_bot() do
    NameGen.Adjective.random_adjective() <> "-" <> NameGen.Noun.random_noun()
  end

  def special() do
    NameGen.Special.random()
  end
end
