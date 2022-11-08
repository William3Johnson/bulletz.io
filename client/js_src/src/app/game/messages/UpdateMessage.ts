import {Bullet, Player, Food, MovingFood, Pickup, State} from 'game/state/types';
import {Score} from 'game/hud/types';

// all possible returns from UpdateMessage
export type UpdateMessage = CreateBullet |
  RemoveBullet |
  CreatePlayer |
  RemovePlayer |
  CreateFood |
  RemoveFood |
  CreateMovingFood |
  RemoveMovingFood |
  CreatePickup |
  RemovePickup |
  Scoreboard |
  State;

export type CreateBullet = Bullet;
export interface RemoveBullet {
  id: string;
}

export type CreatePlayer = Player;
export interface RemovePlayer {
  id: string;
}

export type CreateFood = Food;
export interface RemoveFood {
  id: string;
}

export type CreateMovingFood = MovingFood;
export interface RemoveMovingFood {
  id: string;
}

export type CreatePickup = Pickup;
export interface RemovePickup {
  id: string;
}

export interface Scoreboard {
  scoreboard: Array<Score>;
}
