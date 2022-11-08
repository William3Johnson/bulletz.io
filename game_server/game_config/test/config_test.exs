defmodule GameConfigTest do
  use ExUnit.Case

  describe "FastGlobals are placed for " do
    test "players" do
      assert GameConfig.get(:player) != nil
    end

    test "bullets" do
      assert GameConfig.get(:bullet) != nil
    end

    test "world" do
      assert GameConfig.get(:world) != nil
    end
  end

  test "GameConfig.get works" do
    assert GameConfig.get(:world, :interval) != nil
  end

end
