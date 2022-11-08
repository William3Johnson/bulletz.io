defmodule PowerupsTest do
  use ExUnit.Case

  test "all used sprites exist" do
    all_powerups = Powerups.Agent.effects_list
    Enum.map(all_powerups, fn {_name, _function, sprite, _priority} ->
      assert File.exists?("../../modules/client/assets/static/sprites/"<>sprite)
    end)
  end
end
