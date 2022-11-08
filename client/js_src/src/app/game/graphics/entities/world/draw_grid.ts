import {RenderBox} from 'game/graphics/RenderBox';
import {World} from 'game/state/types';
import {ServerConfig} from 'game/config/ServerConfig';

export function draw_grid(ctx:CanvasRenderingContext2D, renderBox: RenderBox, world: World, config: ServerConfig){
  const {x: x, y: y, width: camera_width, height: camera_height} = renderBox;
  const {"width": world_width, "height": world_height} = world

  const GRID_SIZE = 30;

  const offset_x = renderBox.x % GRID_SIZE;
  const offset_y = renderBox.y % GRID_SIZE;

  ctx.save();

  ctx.strokeStyle = config.world.grid_color;
  ctx.lineWidth =  3;

  ctx.rect(0, 0, world_width, world_height);
  ctx.clip();
  ctx.beginPath();
  for(let i = -GRID_SIZE; i < renderBox.width + GRID_SIZE; i+=GRID_SIZE) {
    ctx.moveTo(i - offset_x, 0);
    ctx.lineTo(i - offset_x, camera_height);
  }

  for(let j = -GRID_SIZE; j < renderBox.height + GRID_SIZE; j+=GRID_SIZE) {
    ctx.moveTo(0,            j - offset_y);
    ctx.lineTo(camera_width, j - offset_y);
  }
  ctx.stroke();

  ctx.restore();
}
