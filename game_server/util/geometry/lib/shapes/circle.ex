defmodule Geometry.Circle do
  use TypedStruct

  typedstruct enforce: true do
    field :location, Geometry.Point.t()
    field :radius, Float.t()
    field :area, Float.t()
  end
  @derive {
    Poison.Encoder,
    only: @enforce_keys
  }

  def set_radius(circle, radius) do
    circle |>
      Map.put(:radius, radius) |>
      Map.put(:area, (radius*radius)*:math.pi())
  end

  def set_area(circle, area) do
    circle |>
      Map.put(:area, area) |>
      Map.put(:radius, :math.sqrt(area/:math.pi))
  end

end
