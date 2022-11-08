defmodule BulletzSocketTest do
  use ExUnit.Case
  doctest BulletzSocket

  test "greets the world" do
    assert BulletzSocket.hello() == :world
  end
end
