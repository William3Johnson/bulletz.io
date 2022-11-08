import {Pickup, World} from "game/state/types";

export function update_pickup(pickup: Pickup, world: World) {
  if (pickup.x + pickup.radius > world.width || pickup.y + pickup.radius > world.height) {
    return null;
  }
  return pickup;
}
