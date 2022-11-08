import {ServerConfig} from "game/config/ServerConfig";
import {RenderBox} from "game/graphics/RenderBox";
import {World} from "game/state/types";

export function draw_boundaries(ctx: CanvasRenderingContext2D, renderBox: RenderBox, world: World, config: ServerConfig) {
  const {x: x, y: y, width: renderBox_width, height: renderBox_height} = renderBox;
  const {"width": world_width, "height": world_height} = world;
  ctx.lineWidth = 5;
  ctx.strokeStyle = config.world.background_boundary;
  ctx.strokeRect(0, 0, world_width, world_height);
}
