import {ServerConfig} from "game/config/ServerConfig";
import {State} from "game/state/types";

import {update_bullet} from "game/state/bullets/update_bullet";
import {update_food} from "game/state/food/update_food";
import {update_moving_food} from "game/state/moving_food/update_moving_food";
import {update_pickup} from "game/state/pickups/update_pickup";
import {update_player} from "game/state/players/update_player";
import {update_world} from "game/state/world/update_world";

export function tick(state: State, current_time: number, config: ServerConfig): State {
  for (const id of Object.keys(state.bullets)) {
      state.bullets[id] = update_bullet(state.bullets[id], current_time, state.world, config);
      if (state.bullets[id] == null) {
        delete state.bullets[id];
      }
  }

  for (const id of Object.keys(state.players)) {
      state.players[id] = update_player(state.players[id], current_time, state.world, config);
      if (state.players[id] == null) {
        delete state.players[id];
      }
  }

  for (const id of Object.keys(state.moving_food)) {
      state.moving_food[id] = update_moving_food(state.moving_food[id], current_time, state.world, config);
      if (state.moving_food[id] == null) {
        delete state.moving_food[id];
      }
  }

  for (const id of Object.keys(state.food)) {
      state.food[id] = update_food(state.food[id], current_time, state.world);
      if (state.food[id] == null) {
        delete state.food[id];
      }
  }

  for (const id of Object.keys(state.pickups)) {
      state.pickups[id] = update_pickup(state.pickups[id], state.world);
      if (state.pickups[id] == null) {
        delete state.pickups[id];
      }
  }

  state.world = update_world(state.world, current_time, state.players, config);

  return state;
}
