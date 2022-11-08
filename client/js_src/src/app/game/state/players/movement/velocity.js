function validate_velocty(velocity, top_speed, frost) {
  if(frost != 0) {
    return validate_velocty_frost(velocity, top_speed, frost)
  } else if(velocity >= 0) {
    return Math.min(top_speed, velocity)
  } else {
    return Math.max(-top_speed, velocity)
  }
}

export function update_velocities(entity, ticks) {
  let result = Object.assign({}, entity);

  const acceleration = entity.acceleration;

  let vel_x_prev = entity.velocity_x;
  let vel_y_prev = entity.velocity_y;

  let vx = entity.velocity_x;
  let vy = entity.velocity_y;

  let accel_x = Math.min(entity.right, 1)*acceleration - Math.min(entity.left, 1)*acceleration
  let accel_y = Math.min(entity.down, 1)*acceleration -  Math.min(entity.up, 1) *acceleration

  vx += accel_x*ticks;
  vy += accel_y*ticks;

  let avg_vx = (entity.velocity_x + entity.velocity_x_prev)/2;
  let avg_vy = (entity.velocity_y + entity.velocity_y_prev)/2;

  let velocity_magnitude = Math.sqrt(Math.pow(avg_vy, 2) + Math.pow(avg_vx, 2));
  let friction_magnitude = velocity_magnitude * (entity.friction + entity.frost)
  if(velocity_magnitude != 0) {
    let friction_x = friction_magnitude * avg_vx/velocity_magnitude
    let friction_y = friction_magnitude * avg_vy/velocity_magnitude
    vx -=friction_x*ticks;
    vy -=friction_y*ticks;
  }


  result.velocity_x = vx;
  result.velocity_y = vy;
  result.velocity_x_prev = vel_x_prev;
  result.velocity_y_prev =  vel_y_prev;

  return result;
}
