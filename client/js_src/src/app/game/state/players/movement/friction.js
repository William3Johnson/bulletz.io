function apply_friction(player, ticks) {
  let result = Object.assign({}, player);

  const friction = player.friction;
  const df = ticks*friction;

  let vx = player.velocity_x;
  let vy = player.velocity_y;

  if(player.left == 0 && player.right == 0) {
    if(vx > 0) {
      vx = Math.max(vx - df, 0);
    }
    else {
      vx = Math.min(vx + df, 0);
    }
  }

  if(player.up == 0 && player.down == 0) {
    if(vy > 0) {
      vy = Math.max(vy - df, 0);
    }
    else {
      vy = Math.min(vy + df, 0)
    }
  }

  result.velocity_x = vx;
  result.velocity_y = vy;

  return result;
}

export {apply_friction}
