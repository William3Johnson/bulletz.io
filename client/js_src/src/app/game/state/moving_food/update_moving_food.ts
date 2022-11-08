import {elapsed_ticks} from "game/util/elapsed_ticks";

import { move } from "game/state/moving_food/move_moving_food";

export function update_moving_food(food, current_time, world, config) {
  const ticks = elapsed_ticks(current_time, food.timestamp, config.world.interval);
  if (food.lifetime - ticks < 0) {
    return null;
  }

  let result = Object.assign({}, food);
  result = move(food, ticks, world);

  result.lifetime = food.lifetime - ticks;
  result.age = food.age + ticks;
  result.timestamp = current_time;

  if (result.x > world.width || result.y > world.height || result.x < 0 || result.y < 0) {
    return null;
  }

  return result;
}
