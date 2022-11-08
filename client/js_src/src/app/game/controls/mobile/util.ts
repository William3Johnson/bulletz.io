export function relative_position(element) {
  return ({x: x, y: y}) => {
    const rel_x = x - element.offsetWidth / 2 - element.offsetLeft;
    const rel_y = y - element.offsetHeight / 2 - element.offsetTop;
    return {x: rel_x, y: rel_y};
  };
}

export function get_x_y(e) {
  const touches = e.targetTouches || e.changedTouches || e.touches;
  if (touches && touches.length != 0) {
    const x = touches[0].pageX;
    const y = touches[0].pageY;
    return {x, y};
  }
  return null;
}

export function prevent_motion(event) {
  event.preventDefault();
  event.stopPropagation();
}

export function get_dx_dy(x, y, start_x, start_y) {
  const dx = x - start_x;
  const dy = y - start_y;
  return {dx, dy};
}

export function calculate_moves({x: x, y: y}) {
  let left = 0;
  let right = 0;
  let up = 0;
  let down = 0;

  const hypotenuse = Math.sqrt(Math.abs(x) ** 2 + Math.abs(y) ** 2);
  if (x > 0) {
    right = Math.abs(x) / hypotenuse;
  } else {
    left = Math.abs(x) / hypotenuse;
  }
  if (y > 0) {
    down = Math.abs(y) / hypotenuse;
  } else {
    up = Math.abs(y) / hypotenuse;
  }

  return { left, right, up, down };
}
