defmodule Collisions do

  def squared_distance(%{x: x1, y: y1}, %{x: x2, y: y2}) do
    dx = x1-x2
    dy = y1-y2
    (dx*dx) + (dy*dy)
  end
  def squared_distance(x1, x2, y1, y2) do
    dx = x1-x2
    dy = y1-y2
    (dx*dx) + (dy*dy)
  end

  def circle_collision?(%{x: x1, y: y1, radius: radius1}, %{x: x2, y: y2, radius: radius2}) do
    distance = squared_distance(x1, x2, y1, y2)
    total_rad = radius1 + radius2
    distance < total_rad*total_rad
  end

  def circle_collision?(_1, _2) do
    false
  end

end
