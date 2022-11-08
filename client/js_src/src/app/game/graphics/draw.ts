import {State} from "game/state/types";

import {ServerConfig} from "game/config/ServerConfig";
import {draw_bullet} from "game/graphics/entities/draw_bullet";
import {draw_food} from "game/graphics/entities/draw_food";
import {draw_move_indicator} from "game/graphics/entities/draw_move_indicator";
import {draw_player} from "game/graphics/entities/draw_player";
import {draw_shoot_indicator} from "game/graphics/entities/draw_shoot_indicator";
import {draw_world} from "game/graphics/entities/world/draw_world";
import {RenderBox} from "game/graphics/RenderBox";
import {MovementIndicator, ShootIndicator} from "game/graphics/types";

//  TODO use this to improve performance
function in_bounds(entity, render_box: RenderBox) {
  const x = entity.x + entity.radius < render_box.x || entity.x - entity.radius > render_box.x + render_box.width;
  const y = entity.y + entity.height < render_box.y || entity.y - entity.radius > render_box.y + render_box.height;
  return !(x || y);
}

export function draw(
  canvas: HTMLCanvasElement,
  ctx: CanvasRenderingContext2D,
  state: State,
  render_box: RenderBox,
  active_player: string | null,
  movement_indicator: MovementIndicator,
  shoot_indicator: ShootIndicator,

  config: ServerConfig) {
    ctx.save();
    try {
      ctx.fillRect(0, 0, canvas.width, canvas.height);

      ctx.scale(1 / render_box.scale, 1 / render_box.scale);
      ctx.translate(-render_box.x, -render_box.y);

      draw_world(canvas, ctx, render_box, state.world,  config);

      const food = state.food;
      Object.keys(food).map((key) => food[key])
          .filter((entity) => in_bounds(entity, render_box))
          .forEach((food) => draw_food(food, ctx));

      const pickups = state.pickups;
      Object.keys(pickups).map((key) => pickups[key])
          .filter((entity) => in_bounds(entity, render_box))
          .forEach((pickup) => draw_food(pickup, ctx));

      const players = state.players;
      Object.keys(players).map((key) => players[key])
          .filter((entity) => in_bounds(entity, render_box))
          .forEach((player) => draw_player(player, ctx, config, render_box));

      const moving_food = state.moving_food;
      Object.keys(moving_food).map((key) => moving_food[key])
          .filter((entity) => in_bounds(entity, render_box))
          .forEach((moving_food) => draw_food(moving_food, ctx));

      const bullets = state.bullets;
      Object.keys(bullets).map((key) => bullets[key])
          .filter((entity) => in_bounds(entity, render_box))
        .forEach((bullet) => draw_bullet(bullet, ctx));

      draw_move_indicator(ctx, active_player ? players[active_player] : null, movement_indicator, render_box);
      draw_shoot_indicator(ctx, active_player ? players[active_player] : null, shoot_indicator);

    } catch (e) {
      console.error(e);
    } finally {
      ctx.restore();
    }
}
