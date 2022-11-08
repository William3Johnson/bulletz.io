import {Observable, ReplaySubject} from "rxjs";
import {share, withLatestFrom} from "rxjs/operators";

import {ServerConfig} from "game/config/ServerConfig";
import {GameEvents} from "game/GameEvents";
import {Bullet, BulletsState, State} from "game/state/types";

import {update_bullet} from "game/state/bullets/update_bullet";
import {update_world} from "game/state/world/update_world";

export class StateReducer {
  public state: ReplaySubject<State>;

  constructor(private game_events: GameEvents) {
    this.state = new ReplaySubject(1);

    this.setupPlayers();
    this.setupBullets();
    this.setupFood();
    this.setupMovingFood();
    this.setupPickups();

    this.game_events.poll.subscribe((state) => {
      this.state.next(state);
    });
  }

  public setupMovingFood() {
    this.game_events.create_moving_food
      .pipe(withLatestFrom(this.state))
      .subscribe(([moving_food, state]) => {
        state.moving_food[moving_food.id] = moving_food;
        this.state.next(state);
      });

    this.game_events.remove_moving_food
      .pipe(withLatestFrom(this.state))
      .subscribe(([{id: id}, state]) => {
        delete state.moving_food[id];
        this.state.next(state);
      });
  }

  public setupFood() {
    this.game_events.create_food
      .pipe(withLatestFrom(this.state))
      .subscribe(([food, state]) => {
        state.food[food.id] = food;
        this.state.next(state);
      });

    this.game_events.remove_food
    .pipe(withLatestFrom(this.state))
    .subscribe(([remove_req, state]) => {
      delete state.food[remove_req.id];
      this.state.next(state);
    });
  }

  public setupPlayers() {
      this.game_events.create_player
        .pipe(withLatestFrom(this.state))
        .subscribe(([player, state]) => {
          state.players[player.id] = player;
          this.state.next(state);
        });

      this.game_events.remove_player
        .pipe(withLatestFrom(this.state))
        .subscribe(([remove_req, state]) => {
          delete state.players[remove_req.id];
          this.state.next(state);
        });
  }

  public setupBullets() {
    this.game_events.create_bullet
      .pipe(withLatestFrom(this.state))
      .subscribe(([bullet, state]) => {
        state.bullets[bullet.id] = bullet;
        this.state.next(state);
      });

    this.game_events.remove_bullet
      .pipe(withLatestFrom(this.state))
      .subscribe(([remove_req, state]) => {
        delete state.bullets[remove_req.id];
        this.state.next(state);
      });
  }

  private setupPickups() {
    this.game_events.create_pickup
      .pipe(withLatestFrom(this.state))
      .subscribe(([pickup, state]) => {
        state.pickups[pickup.id] = pickup;
        this.state.next(state);
      });

    this.game_events.remove_pickup
    .pipe(withLatestFrom(this.state))
    .subscribe(([remove_req, state]) => {
      delete state.pickups[remove_req.id];
      this.state.next(state);
    });
  }
}
