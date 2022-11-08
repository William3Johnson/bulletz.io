export function safe_draw_image(ctx: CanvasRenderingContext2D, image, x, y, width, height) {
  try {
    ctx.drawImage(image, x, y, width, height);
  } catch (e) {
    console.error(e);
  }
}
