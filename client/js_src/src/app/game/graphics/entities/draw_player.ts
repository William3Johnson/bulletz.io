import {ServerConfig} from "game/config/ServerConfig";
import { get_sprite, get_spritesheet } from "game/graphics/util/sprite_cache";
import { safe_draw_image } from "../util/safe_draw_image";

import {RenderBox} from "../RenderBox";

import {Player} from "game/state/types";

import {font_size, get_font} from "game/graphics/util/font";

function draw_player_normal(x, y, radius, min_radius, inner_age, line_width, color, ctx) {
  ctx.strokeStyle = color;
  ctx.beginPath();
  ctx.arc(x, y, radius, 0, 2 * Math.PI * inner_age);
  ctx.stroke();
}

export function draw_player(player: Player, ctx: CanvasRenderingContext2D, config: ServerConfig, render_box: RenderBox) {
   const {
      "x": x,
      "y": y,
      "color": color,
      "radius": radius,
      "age": age,
      "name": name,
      "sprite": sprite,
      "opacity": opacity,
      "spritesheet": spritesheet,
      "background_color": background_color,
      "min_radius": min_radius,
      "line_width": line_width,
      "death_mark": death_mark,
      "death_mark_timer": death_mark_timer,
  } = player;

   const inner_age = age / config.player.max_age;
   ctx.save();
   try {
    ctx.globalAlpha = opacity;
    ctx.lineWidth = 1 + ((line_width) * (radius / min_radius) * render_box.scale);
    ctx.strokeStyle = color;

    if (background_color) {
      ctx.beginPath();
      ctx.arc(x, y, radius, 0, 2 * Math.PI * inner_age);
      ctx.stroke();
    }
    if (spritesheet) {
      const sprite = get_spritesheet("/images/spritesheets/" + spritesheet.image, spritesheet.width, spritesheet.height, spritesheet.percent, spritesheet.frames);
      safe_draw_image(ctx, sprite.get_frame(spritesheet.percent), x - radius, y - radius, 2 * radius, 2 * radius);
      if (spritesheet.background) {
        draw_player_normal(x, y, radius, min_radius, inner_age, line_width, color, ctx);
      }
    } else if (sprite) {
      const image = get_sprite("/images/sprites/" + sprite);
      safe_draw_image(ctx, image, x - radius, y - radius, 2 * radius, 2 * radius);
    } else {
      draw_player_normal(x, y, radius, min_radius, inner_age, line_width, color, ctx);
    }

    ctx.fillStyle = color;
    ctx.font = get_font(font_size() * render_box.scale);
    const w = ctx.measureText(name).width;
    ctx.fillText(name, (x - radius) + (2 * radius - w) / 2, y + (radius) + ctx.lineWidth + (font_size() * render_box.scale) + 3);

    if (death_mark) {
      ctx.fillStyle = "rgba(255, 0, 0, " + Math.abs(Math.cos(death_mark_timer / 150)) + ")";
      ctx.beginPath();
      ctx.arc(x, y, radius + ctx.lineWidth, 0, 2 * Math.PI * inner_age);
      ctx.fill();
    }

    // TODO(lukewood) draw frost
  } finally {
    ctx.restore();
  }
}
