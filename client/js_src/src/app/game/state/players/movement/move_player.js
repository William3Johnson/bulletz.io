import {create_validation_function} from 'game/util/create_validation_function';

function average(n1, n2){
  return n1/2 + n2/2;
}

function move_player(entity, ticks, {"width": world_width, "height": world_height}) {
  const result = Object.assign({}, entity);

  const validate_player_x = create_validation_function(entity.radius, world_width-entity.radius);
  const validate_player_y = create_validation_function(entity.radius, world_height-entity.radius);

  if(entity.stuck > 0) {
    result.velocity_x = 0;
    result.velocity_y = 0;
    result.stuck = Math.max(entity.stuck - ticks, 0);
    result.x = validate_player_x(entity.x)
    result.y = validate_player_x(entity.y)
  } else {
    const vx = average(entity.velocity_x, entity.velocity_x_prev) * ticks
    const vy = average(entity.velocity_y, entity.velocity_y_prev) * ticks
    result.x = validate_player_x(entity.x + vx);
    result.y = validate_player_y(entity.y + vy);
  }

  return result;
}

export {move_player}
