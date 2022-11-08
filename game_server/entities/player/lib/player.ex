defmodule Player do

  defdelegate new(kwargs),  to: Player.Supervisor

  defdelegate action_direct(pid, direction, percentage), to: Player.Client
  defdelegate action(pid, activation, action),           to: Player.Client
  defdelegate effect(pid, effect),                       to: Player.Client
  defdelegate change_target(pid, target),                to: Player.Client
  defdelegate shoot(pid, target),                        to: Player.Client
  defdelegate tick(pid, world_state),                    to: Player.Client
  defdelegate restore_state(player),                     to: Player.Impl

  @derive {
    Poison.Encoder,
    only: [
      # Movement
      :x,
      :y,
      :velocity_x,
      :velocity_y,
      :velocity_x_prev,
      :velocity_y_prev,

      :top_speed,

      :frost,
      :stuck,
      :acceleration,
      :friction,
      :up,
      :down,
      :left,
      :right,

      # Data
      :id,
      :radius,
      :min_radius,
      :timestamp,
      :reload_time,
      :reload,

      #graphics
      :age,
      :name,
      :sprite,
      :stall_opacity,
      :opacity,
      :opacity_dx,
      :color,
      :background_color,
      :spritesheet,

      :line_width,

      :hide_aim,

      :death_mark,
      :death_mark_timer
    ]
  }

  defstruct [
    x:              0,
    y:              0,
    velocity_x:     0,
    velocity_y:     0,
    velocity_x_prev: 0,
    velocity_y_prev: 0,

    top_speed:      0,
    frost:          0,

    left:           0,
    right:          0,
    up:             0,
    down:           0,

    acceleration:   0,
    friction:       0,

    id:             nil,
    radius:         0,
    starting_radius: 0,
    min_radius:     0,
    max_radius:     0,
    color:          nil,
    background_color: nil,
    world:          nil,
    timestamp:      0,
    age:            0,
    name:           "",
    sprite:         nil,
    spritesheet:    nil,
    stall_opacity:  0,
    opacity: 1.0,
    opacity_dx: 0,
    stuck: 0,

    # shooting info
    reload:          0,
    reload_time:     0,
    target:          %{x: 0, y: 0},
    shoot_callback:  nil,
    update_callback: nil,
    afk_timer:      2000,
    death_callback:  nil,
    hit_callback:    nil,

    line_width:       1,

    pid: nil,
    mobile: false,
    hide_aim: false,

    death_mark: false,
    death_mark_timer: 0,

    pickup_priority: 0,

    bullet_damage_mod:  1,
    bullet_size_mod:  1,
    bullet_speed_mod:  1,
    bullet_end_speed_mod: 1,
    bullet_sprite: nil,
    bullet_color: nil,
    bullet_slowdown_duration_mod: 1,
    bullet_lifetime_mod: 1,
    growth_rate_mod: 1,
    extra_data: nil,
    invincible: false,
    extra_callbacks: []
  ]

end
