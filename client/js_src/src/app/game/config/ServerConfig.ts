export interface ServerConfig {
  world: WorldConfig;
  player: PlayerConfig;
  ghost: GhostConfig;
  frost: FrostConfig;
  bullet: BulletConfig;
}

export interface WorldConfig {
  width: number;
  max_players: number;
  interval: number;
  height: number;
  area_per_player: number;
  dx: number;

  grid_color?: string;
  background_image?: string;
  background_boundary?: string;
  background?: string;
}

export interface PlayerConfig {
  reload: number;
  radius: number;
  min_radius: number;
  max_age: number;
  friction: number;
  afk_timer: number;
  acceleration: number;
  death_timer: number;
}

export interface GhostConfig {
  stall_visible: number;
  stall_invisible: number;
}

export interface FrostConfig {
  thaw_rate: number;
  max_frost: number;
}

export interface BulletConfig {
    speed: number;
    slowdown_duration: number;
    parent_radius_ratio: number;
    lifetime: number;
    global_damage_mod: number;
}
