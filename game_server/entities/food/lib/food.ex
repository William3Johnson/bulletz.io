defmodule Food do

  defdelegate new(kwargs), to: Food.Impl
  defdelegate consume_food(food, player), to: Food.Impl
  defdelegate remove_food(food), to: Food.Impl
  @derive {
    Poison.Encoder,
    only: [
      :x,
      :y,
      :radius,
      :color,
      :id,
      :line_width,
      :lifetime
    ]
  }
  defstruct [
    x: 0,
    y: 0,
    lifetime: 0,
    timestamp: 0,
    world:  nil,
    radius: nil,
    id:     nil,
    tref: nil,
    line_width: 2,
    color:  "#FFFFFF",
  ]

end
