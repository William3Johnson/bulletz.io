export interface JoinRequest {
  name: string,
  mobile: boolean
}

export interface DesktopMoveRequest {
  action: string
}

export interface DesktopShootRequest {
  x: number;
  y: number;
}

export interface MobileMoveRequest {
  up: number;
  down: number;
  left: number;
  right: number;
}

export interface MobileShootRequet {
  x: number;
  y: number;
}

export type InputRequest = JoinRequest | DesktopMoveRequest | DesktopShootRequest | MobileMoveRequest | MobileShootRequet;
