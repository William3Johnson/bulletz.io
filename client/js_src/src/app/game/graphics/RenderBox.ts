import {ServerConfig} from "game/config/ServerConfig";
import {Player} from "game/state/types";

import {Dims} from "game/graphics/types";
import {screen_dimensions} from "game/graphics/util/screen_dimensions";

export interface RenderBox {
  x: number;
  y: number;
  width: number;
  height: number;
  scale: number;
  initial_state: boolean;
}

export function update_render_box(render_box: RenderBox, player: Player, config: ServerConfig): RenderBox {

  const dims = screen_dimensions();

  const times_bigger = Math.max(1, player.radius / config.player.radius);

  const device_factor = Math.max(1, 1.5 * 304500 / (dims.width * dims.height));

  const target_zoom = device_factor * (2 + player.radius / 200); // Math.floor(1.5 + (Math.max(5, times_bigger))) / 6;
  (player.radius * player.radius);
  if (render_box.initial_state) {
    render_box.initial_state = false;
    render_box.scale = target_zoom;
    render_box.width = dims.width * render_box.scale;
    render_box.height = dims.height * render_box.scale;
    render_box.x = player.x - render_box.width / 2;
    render_box.y = player.y - render_box.height / 2;
    return render_box;
  }

  render_box.scale = tween_from_to(
    render_box.scale,
    target_zoom,
  );

  render_box.width = dims.width * render_box.scale;
  render_box.height = dims.height * render_box.scale;

  render_box.x = tween_from_to(
     render_box.x,
     player.x - render_box.width / 2,
     .0005,
     5,
     10,
  );

  render_box.y = tween_from_to(
     render_box.y,
     player.y - render_box.height / 2,
     .0005,
     5,
     10,
  );

  return render_box;
}

function tween_from_to(actual, target, rate: number =  .0025,  min_change: number = .00025, stick_min: number = 0.0002) {
  const abs_diff = Math.abs(actual - target);
  const dx = Math.max(min_change, rate * (abs_diff ** 2));

  if (abs_diff < stick_min) {
    return target;
  } else if (actual < target) {
    return Math.min(actual + dx, target);
  } else  if (actual > target) {
    return Math.max(actual - dx, target);
  }

}
