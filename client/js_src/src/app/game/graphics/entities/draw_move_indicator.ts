import {MovementIndicator, MovementIndicatorPresent} from "game/graphics/types";
import {Player} from "game/state/types";

import {RenderBox} from "../RenderBox";

export function draw_move_indicator(ctx: CanvasRenderingContext2D, player: Player, move_indicator: MovementIndicator, render_box: RenderBox) {
  if (player == null || move_indicator == null) {
    return;
  }

  const move_indicator_present: MovementIndicatorPresent = move_indicator as MovementIndicatorPresent;

  ctx.lineWidth = Math.max(2, (player.radius / player.min_radius));
  ctx.lineCap = "square";
  ctx.strokeStyle = "#EEEEEE";
  ctx.beginPath();

  const hypotenuse_len = Math.sqrt(move_indicator_present.dx ** 2 + move_indicator_present.dy ** 2);
  const sin = move_indicator_present.dx / hypotenuse_len;
  const cos = move_indicator_present.dy / hypotenuse_len;

  const fromx = player.x + sin * player.radius;
  const fromy = player.y + cos * player.radius;

  const indicator_length = Math.min(2.5 * Math.max(player.radius, 30), render_box.scale * hypotenuse_len * 2);

  const tox = fromx + sin * indicator_length;
  const toy = fromy + cos * indicator_length;
  const angle = Math.atan2(toy - fromy, tox - fromx);

  const headlen = Math.max(player.radius / 2, 20);

  // starting a new path from the head of the arrow to one of the sides of the point
  ctx.beginPath();
  ctx.moveTo(tox, toy);
  ctx.lineTo(tox - headlen * Math.cos(angle - Math.PI / 4), toy - headlen * Math.sin(angle - Math.PI / 4));

  ctx.moveTo(tox, toy);
  ctx.lineTo(tox - headlen * Math.cos(angle + Math.PI / 4), toy - headlen * Math.sin(angle + Math.PI / 4));
  // path from the side point back to the tip of the arrow, and then again to the opposite side point
  ctx.stroke();
}
