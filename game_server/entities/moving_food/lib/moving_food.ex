defmodule MovingFood do

  defdelegate for_player_death(size, player, world_state), to: MovingFood.Supervisor
  defdelegate from_hit(bullet, player, world_state), to: MovingFood.Supervisor
  defdelegate tick(pid, world_state), to: MovingFood.Client
  defdelegate stop(pid), to: MovingFood.Client

  @derive {
    Poison.Encoder,
    only: [
      :x,
      :y,
      :velocity_x,
      :velocity_y,
      :velocity_x_prev,
      :velocity_y_prev,
      :radius,
      :color,
      :timestamp,
      :lifetime,
      :speed,
      :id,
      :line_width,
      :age,
      :vx_slowdown,
      :vy_slowdown,
      :slowdown_duration,
      :moving_food,
      :sprite
    ]
  }
  defstruct [
    damage:      1,
    x:           0,
    y:           0,
    velocity_x:  0,
    velocity_y:  0,
    velocity_x_prev:  0,
    velocity_y_prev:  0,
    vx_slowdown: 0,
    vy_slowdown: 0,
    age:         0,
    speed:       0,
    sprite:        nil,
    world:       nil,
    lifetime:    0,
    radius:      1,
    parent_radius: 0,
    color:       "#000000",
    timestamp:   0,
    parent_id:   nil,
    parent_name: "",
    id:          "",
    slowdown_duration: 100,
    effect: nil,
    moving_food: true,
    line_width: 2,
  ]

end
