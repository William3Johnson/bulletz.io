export interface State {
  bullets: BulletsState;
  players: PlayersState;
  pickups: PickupsState;
  food: FoodState;
  moving_food: MovingFoodState;
  world: World;
}

export type PlayersState = Map<string, Player>;
export interface Player {
  x: number;
  y: number;
  velocity_x: number;
  velocity_y: number;
  velocity_x_prev: number;
  velocity_y_prev: number;
  top_speed: number;

  frost: number;
  stuck: number;
  acceleration: number;
  friction: number;
  up: number;
  down: number;
  left: number;
  right: number;

  id: string
  radius: number;
  min_radius: number;
  timestamp: number;
  reload_time: number;
  reload: number;

  age: number;
  name: string;
  sprite: string;
  stall_opacity: number;
  opacity: number;
  opacity_dx: number;
  color: string;
  background_color: string;
  spritesheet: any;

  line_width: number;

  hide_aim: boolean;
  death_mark: boolean;
  death_mark_timer: number;
}

export type BulletsState = Map<string, Bullet>;
export interface Bullet {
  x: number;
  y: number;
  x_origin: number;
  y_origin: number;
  velocity_x: number;
  velocity_y: number;
  velocity_x_prev: number;
  velocity_y_prev: number;
  radius: number;
  color: string;
  timestamp: number;
  lifetime: number;
  sprite: string;
  id: string;
  age: number;
  line_width: number;
  vx_slowdown: number;
  vy_slowdown: number;
  slowdown_duration: number;
}

type FoodState = Map<string, Food>;
export interface Food {
  x: number;
  y: number;
  radius: number;
  color: number;
  id: number;
  line_width: number;
  lifetime: number;
}


type MovingFoodState = Map<string, MovingFood>;
export interface MovingFood {
  x: number
  y: number
  velocity_x: number
  velocity_y: number
  velocity_x_prev: number
  velocity_y_prev: number
  radius: number
  timestamp: number
  lifetime: number
  speed: number
  line_width: number
  age: number
  vx_slowdown: number
  vy_slowdown: number
  slowdown_duration: number
  moving_food: boolean

  color: string
  id: string
  sprite?: string
}

type PickupsState = Map<string, Pickup>;
export interface Pickup {
  x: number
  y: number
  radius: number
  name: string
  color: string
  id: string
  sprite: string
}

export interface World {
  width: number;
  height: number;
  timestamp: number;
}
