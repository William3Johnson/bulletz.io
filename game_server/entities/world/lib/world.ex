defmodule World do

  alias World.Client,     as: Client

  defdelegate new_player(pid, player),            to: Client
  defdelegate remove_player(pid, player_pid, player_state),         to: Client

  defdelegate new_bullet(pid, bullet, bullet_state),            to: Client
  defdelegate remove_bullet(pid, bullet),         to: Client

  defdelegate new_food(pid, food),            to: Client
  defdelegate remove_food(pid, food),     to: Client

  defdelegate new_pickup(pid, pickup, pickup_state),        to: Client
  defdelegate remove_pickup(pid, pid2, id),     to: Client

  defdelegate new_moving_food(pid, food),               to: Client
  defdelegate remove_moving_food(pid, food, id),        to: Client
  defdelegate remove_moving_food(pid, food),            to: Client

  defdelegate tick(pid), to: Client

  @derive {
    Poison.Encoder,
    only: [
      :width,
      :height,
      :timestamp,
    ]
  }
  defstruct [
    players:                 [],
    bullets:                 [],
    food:                    [],
    pickups:                 [],
    moving_food:             [],
    width:                   0,
    height:                  0,
    timestamp:               0,
    kill_player:             nil,
    broadcast_bullet:        nil,
    broadcast_food:          nil,
    broadcast_moving_food:   nil,
    broadcast_pickup:        nil,
    remove_pickup:           nil,
    create_food:             nil,
    remove_food:             nil,
    remove_moving_food:      nil,
  ]

end
