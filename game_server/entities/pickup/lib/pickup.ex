defmodule Pickup do

  defdelegate new(kwargs), to: Pickup.Supervisor
  defdelegate tick(state, world), to: Pickup.Client
  defdelegate stop(pid), to: Pickup.Client
  
  @derive {
    Poison.Encoder,
    only: [
      :x,
      :y,
      :radius,
      :name,
      :color,
      :id,
      :sprite
    ]
  }
  defstruct [
    x: 0,
    y: 0,
    world:  nil,
    effect: nil,
    radius: nil,
    priority: 0,
    name:   "",
    id:     nil,
    color:  "#000000",
    sprite: nil,
  ]

end
