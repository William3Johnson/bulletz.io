defmodule BucketizerTest do
  use ExUnit.Case
  doctest Bucketizer

  test "greets the world" do
    assert Bucketizer.hello() == :world
  end
end
