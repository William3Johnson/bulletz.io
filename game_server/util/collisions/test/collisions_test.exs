defmodule CollisionsTest do
  use ExUnit.Case

  test "circular collisions" do
    obj_1 = %{x: 0, y: 0, radius: 1}
    obj_2 = %{x: 1, y: 1, radius: 2}

    assert Collisions.circle_collision?(obj_1, obj_2) == true

    obj_2 = %{x: 5, y: 1, radius: 2}
    assert Collisions.circle_collision?(obj_1, obj_2) == false
  end
end
