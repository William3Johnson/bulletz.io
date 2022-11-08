import {draw_boundaries}       from "./draw_boundaries";
import {draw_grid}       from "./draw_grid";

import {ServerConfig} from "game/config/ServerConfig";
import {RenderBox} from "game/graphics/RenderBox";
import {World} from "game/state/types";

export function draw_world(canvas: HTMLCanvasElement, ctx: CanvasRenderingContext2D, renderBox: RenderBox, world: World, config: ServerConfig) {
    ctx.fillStyle = config.world.background;
    ctx.fillRect(0, 0, renderBox.width, renderBox.height);
    // draw_grid(ctx, renderBox, world, config);
    draw_boundaries(ctx, renderBox, world, config);
}
