defmodule Geometry.Point do
  use TypedStruct

  typedstruct enforce: true do
    field :x, Float.t()
    field :y, Float.t()
  end
  @derive {
    Poison.Encoder,
    only: @enforce_keys
  }

end
