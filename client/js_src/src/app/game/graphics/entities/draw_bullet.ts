import { safe_draw_image } from "game/graphics/util/safe_draw_image";
import { get_sprite } from "game/graphics/util/sprite_cache";

import {Bullet} from "game/state/types";

const GRADIENT_STRENGTH_MAX = .25;

export function draw_bullet(bullet: Bullet, ctx: CanvasRenderingContext2D) {
    const {
      "x": x,
      "y": y,
      "x_origin": x_origin,
      "y_origin": y_origin,
      "color": color,
      "radius": radius,
      "line_width": line_width,
      "lifetime": lifetime,
      "age": age,
      "slowdown_duration": slowdown_duration,
      "sprite": sprite,
    } = bullet;
    if (bullet.color != "none") {
      const gradient = ctx.createLinearGradient(x, y, x_origin, y_origin);
      gradient.addColorStop(0, color);
      const gradientStrength = Math.max(GRADIENT_STRENGTH_MAX * ((slowdown_duration - age) / slowdown_duration), 0);
      gradient.addColorStop(gradientStrength, color + "00");

      ctx.strokeStyle = gradient;
      ctx.lineWidth = radius * 3;
      ctx.lineCap = "round";

      if (gradientStrength > 0) {
        ctx.beginPath();
        ctx.moveTo(x, y);
        ctx.lineTo(x_origin, y_origin);
        ctx.stroke();
      }
    }

    if (sprite) {
      const image = get_sprite("/images/sprites/" + sprite);
      safe_draw_image(ctx, image, x - radius, y - radius, 2 * radius, 2 * radius);
    } else {
      ctx.fillStyle = color;
      ctx.beginPath();
      ctx.arc(x, y, radius, 0, 2 * Math.PI);
      ctx.fill();
    }
}
