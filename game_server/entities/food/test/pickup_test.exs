defmodule PickupTest do
  use ExUnit.Case

  setup_all do
    {:ok, world} = World.new
    {:ok, player} = Player.new(world: world, name: "", update_callback: &(&1), death_callback: &(&1))
    {:ok,
      %{
        world:  world,
        player: player
      }
    }
  end

end
