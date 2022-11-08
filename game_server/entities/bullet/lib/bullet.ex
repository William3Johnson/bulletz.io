defmodule Bullet do

  defdelegate new(player, world_state), to: Bullet.Supervisor
  defdelegate new(player, world_state, optargs), to: Bullet.Supervisor
  defdelegate tick(pid, world_state), to: Bullet.Client
  defdelegate stop(pid), to: Bullet.Client
  @derive {
    Poison.Encoder,
    only: [
      :x,
      :y,
      :x_origin,
      :y_origin,
      :velocity_x,
      :velocity_y,
      :velocity_x_prev,
      :velocity_y_prev,
      :radius,
      :color,
      :timestamp,
      :lifetime,
      :sprite,
      :id,
      :age,
      :line_width,
      :vx_slowdown,
      :vy_slowdown,
      :slowdown_duration
    ]
  }
  defstruct [
    damage:      1,

    x:           0,
    y:           0,
    x_origin:    0,
    y_origin:    0,
    velocity_x:  0,
    velocity_y:  0,
    velocity_x_prev:  0,
    velocity_y_prev:  0,
    vx_slowdown: 0,
    vy_slowdown: 0,
    speed:       0,
    world:       nil,
    lifetime:    0,
    radius:      1,
    color:       "#000000",
    timestamp:   0,
    parent_id:   nil,
    parent_name: "",
    id:          "",
    age:         0,
    slowdown_duration: 0,

    line_width: 3,

    sprite: nil,

    extra_callbacks: [],
  ]

end
