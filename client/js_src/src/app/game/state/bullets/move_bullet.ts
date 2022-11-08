function average(n1, n2) {
  return n1 / 2 + n2 / 2;
}

function move(bullet, ticks, {"width": world_width, "height": world_height}) {
  const result = Object.assign({}, bullet);
  const {x: x, y: y} = result;
  const vx = average(bullet.velocity_x, bullet.velocity_x_prev);
  const vy = average(bullet.velocity_y, bullet.velocity_y_prev);

  let dx = ticks * vx;
  let dy = ticks * vy;
  let set_origin = false;
  if ((x + dx) >= world_width || (x + dx) <= 0) {
    result.velocity_x *= -1;
    result.vx_slowdown *= -1;
    dx = ticks * vx;
    set_origin = true;
  }

  if ((y + dy) >= world_height || y + dy <= 0) {
    result.velocity_y *= -1;
    result.vy_slowdown *= -1;
    dy = ticks * vy;
    set_origin = true;
  }

  result.velocity_y_prev = result.velocity_y;
  result.velocity_x_prev = result.velocity_x;
  if (bullet.age < bullet.slowdown_duration) {
    result.velocity_x -= result.vx_slowdown * ticks;
    result.velocity_y -= result.vy_slowdown * ticks;
    result.x = x + dx;
    result.y = y + dy;
  } else {
    result.velocity_x = 0;
    result.velocity_y = 0;
    result.velocity_x_prev = 0;
    result.velocity_y_prev = 0;
    result.vx_slowdown = 0;
    result.vy_slowdown = 0;
  }

  if (result.x > world_width) {
    result.x = world_width;
    set_origin = true;
  }
  if (result.x < 0) {
    result.x = 0;
    set_origin = true;
  }
  if (result.y > world_height) {
    result.y = world_height;
    set_origin = true;
  }
  if (result.y < 0) {
    result.y = 0;
    set_origin = true;
  }

  if (set_origin) {
    result.x_origin = x + dx;
    result.y_origin = y + dy;
  }

  return result;
}

export {move};
