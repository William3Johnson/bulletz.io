import {elapsed_ticks} from "game/util/elapsed_ticks";
import {move} from "./move_bullet";

import {ServerConfig} from "game/config/ServerConfig";
import {Bullet, State, World} from "game/state/types";

export function update_bullet(bullet: Bullet, current_time: number, world: World, config: ServerConfig): Bullet {
  const ticks = elapsed_ticks(current_time, bullet.timestamp, config.world.interval);

  if (bullet.lifetime - ticks < 0) {
    return null;
  }

  const result = move(bullet, ticks, world);
  result.lifetime = bullet.lifetime - ticks;
  result.age = bullet.age + ticks;
  result.timestamp = current_time;

  return result;
}
