import { safe_draw_image } from "game/graphics/util/safe_draw_image";
import { get_sprite } from "game/graphics/util/sprite_cache";

export function draw_food(food, ctx) {
    const {
      "x": x,
      "y": y,
      "radius": radius,
      "color": color,
      "sprite": sprite,
      "moving_food": moving_food,
      "line_width": line_width,
    } = food;
    if (!sprite) {
      ctx.strokeStyle = color;
      ctx.lineWidth = line_width;
      ctx.beginPath();
      ctx.arc(x, y, radius, 0, 2 * Math.PI);
      ctx.stroke();
    } else {
      const image = get_sprite("/images/sprites/" + sprite);
      safe_draw_image(ctx, image, x - radius, y - radius, 2 * radius, 2 * radius);
    }
}
