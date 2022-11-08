import {ShootIndicator, ShootIndicatorPresent} from "game/graphics/types";

export function draw_shoot_indicator(ctx, player, shoot_indicator) {
  if (player == null || player.hide_aim || shoot_indicator == null) {
    return;
  }
  const shoot_indicator_present: ShootIndicatorPresent = shoot_indicator as ShootIndicatorPresent;

  ctx.lineWidth = 1 + player.line_width * (player.radius / player.min_radius);
  ctx.lineWidth *= 2;
  ctx.lineCap = "round";
  ctx.strokeStyle = player.color;
  ctx.beginPath();

  const indicator_length = player.radius * 4 / 5;
  const hypotenuse_len = Math.sqrt(shoot_indicator_present.dx ** 2 + shoot_indicator_present.dy ** 2);
  const sin = shoot_indicator_present.dx / hypotenuse_len;
  const cos = shoot_indicator_present.dy / hypotenuse_len;

  const origin_x = player.x + sin * (ctx.lineWidth / 2 + player.radius);
  const origin_y = player.y + cos * (ctx.lineWidth / 2 + player.radius);
  ctx.moveTo(origin_x, origin_y);
  ctx.lineTo(origin_x + sin * indicator_length, origin_y + cos * indicator_length);
  ctx.stroke();
}
