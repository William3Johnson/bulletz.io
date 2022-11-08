import {elapsed_ticks} from "game/util/elapsed_ticks";

import {ServerConfig} from "game/config/ServerConfig";
import {Bullet, PlayersState, State, World} from "game/state/types";

export function update_world(state: World, current_time: number, players: PlayersState, config: ServerConfig) {
  const BASE_WIDTH = config.world.width;
  const BASE_HEIGHT = config.world.height;
  const area_per_player = config.world.area_per_player;
  const dx = config.world.dx;
  const width = state.width;
  const height = state.height;
  const timestamp = state.timestamp;

  const total_players = Object.keys(players).length;
  const target_size = BASE_WIDTH * BASE_HEIGHT + area_per_player * total_players;
  const target_side = Math.sqrt(target_size);
  const area = width * height;

  const result = Object.assign({}, state);

  const ticks = elapsed_ticks(current_time, timestamp, config.world.interval);

  if (area < target_size) {
    result.width = Math.min(target_side, width + dx * ticks);
    result.height = Math.min(target_side, height + dx * ticks);
  } else if (area > target_size) {
    result.width = Math.max(target_side, width - dx * ticks);
    result.height = Math.max(target_side, height - dx * ticks);
  }

  result.timestamp = current_time;
  return result;
}
