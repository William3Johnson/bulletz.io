import {Observable} from 'rxjs';
import {CreateBullet, RemoveBullet, RemovePlayer, CreatePlayer, CreatePickup, RemovePickup, CreateFood, RemoveFood, CreateMovingFood, RemoveMovingFood} from 'game/messages/UpdateMessage'
import {State} from 'game/state/types';

export interface GameEvents {
  create_bullet: Observable<CreateBullet>;
  remove_bullet: Observable<RemoveBullet>;

  create_player: Observable<CreatePlayer>;
  remove_player: Observable<RemovePlayer>;

  create_food: Observable<CreateFood>;
  remove_food: Observable<RemoveFood>;

  create_moving_food: Observable<CreateMovingFood>;
  remove_moving_food: Observable<RemoveMovingFood>;

  create_pickup: Observable<CreatePickup>;
  remove_pickup: Observable<RemovePickup>;

  poll: Observable<State>;
}
