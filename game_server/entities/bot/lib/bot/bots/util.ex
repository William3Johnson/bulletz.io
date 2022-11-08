defmodule Bot.Util do
  def closest_player(%{x: x, y: y, id: id}, players) do
    player_coords = %{x: x, y: y}
    players |>
      Enum.map(&Peek.peek/1) |>
      Enum.filter(&(&1 != nil)) |>
      Enum.filter(&(Map.get(&1, :opacity) != 0)) |>
      Enum.filter(fn p -> Map.get(p, :id) != id end) |>
      Enum.min_by(fn p -> Collisions.squared_distance(p, player_coords)-Map.get(p, :radius, 0) end, fn -> nil end)
  end

  def closest_moving_food(%{x: x, y: y, id: id}, foods) do
    player_coords = %{x: x, y: y}
    foods |>
      Enum.map(&Peek.peek/1) |>
      Enum.filter(&(&1 != nil)) |>
      Enum.filter(fn f -> Map.get(f, :parent_id) != id end) |>
      Enum.min_by(fn f -> Collisions.squared_distance(f, player_coords) end, fn -> nil end)
  end
end
