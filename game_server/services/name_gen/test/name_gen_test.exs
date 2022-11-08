defmodule NameGenTest do
  use ExUnit.Case
  doctest NameGen

  test "greets the world" do
    assert NameGen.hello() == :world
  end
end
