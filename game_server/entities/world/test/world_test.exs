defmodule WorldTest do

  use ExUnit.Case

  describe "Worlds can " do

    test "have players added" do
      {:ok, world} = World.new
      {:ok, placeholder} = Agent.start_link(fn -> [] end)
      World.new_player(world, placeholder)
      assert Peek.peek(world) |> Map.get(:players) |> Enum.count == 1
    end

   end

end
