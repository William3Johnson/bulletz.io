function update_food(food, current_time, world) {
  if (food.lifetime + food.timestamp > current_time) {
    return null;
  }
  if (food.x > world.width || food.y > world.height || food.x < 0 || food.y < 0) {
    return null;
  }
  return food;
}

export {update_food};
