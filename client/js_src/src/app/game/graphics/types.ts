export interface Dims {
  width: number;
  height: number;
}

export interface MovementIndicatorPresent {
  dx: number;
  dy: number;
}

export interface ShootIndicatorPresent {
  dx: number;
  dy: number;
}

export type MovementIndicator = MovementIndicatorPresent | void;
export type ShootIndicator = ShootIndicatorPresent | void;
