import {elapsed_ticks} from "game/util/elapsed_ticks";

import {apply_friction} from "./movement/friction";
import {move_player} from "./movement/move_player";
import {update_velocities} from "./movement/velocity";

function update_opacity(player, ticks, config) {
  if (player.stall_opacity > 0) {
    player.stall_opacity = player.stall_opacity - ticks;
    return player;
  }

  const result = player.opacity + (player.opacity_dx * ticks);
  if (result > 1) {
    // TODO remove hardcode
    player.stall_opacity = config.ghost.stall_visible;
    player.opacity = 1;
    player.opacity_dx = -player.opacity_dx;
  } else if (result < 0) {
    player.stall_opacity = config.ghost.stall_invisible;
    player.opacity = 0;
    player.opacity_dx = -player.opacity_dx;
  } else {
    player.opacity = result;
  }
  return player;
}

export function update_player(player, current_time, world, config) {
    const ticks = elapsed_ticks(current_time, player.timestamp, config.world.interval);
    player.timestamp = current_time;

    if (player.death_mark) {
      player.death_mark_timer -= ticks;
      return player;
    }

    let result = update_velocities(player, ticks);
    result = move_player(result, ticks, world);
    result = apply_friction(result, ticks);
    result = update_opacity(result, ticks, config);

    result.frost = Math.max(player.frost - (config.frost.thaw_rate * ticks), 0);
    result.age = Math.min(200, player.age + ticks);
    result.space_cooldown_time = player.space_cooldown_time - ticks;
    return result;
}
