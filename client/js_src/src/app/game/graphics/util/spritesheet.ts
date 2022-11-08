const all_sprites = [];

function Sprite(imagesrc, width, height, percent, num_frames) {
  const image = new Image();
  let current_frame = 0;
  const frames = [];

  function create_canvas() {
    const canvas = document.createElement("canvas");
    canvas.width = width;
    canvas.height = height;
    return canvas;
  }

  function draw_frame(canvas, frame) {
    const ctx = canvas.getContext("2d");
    percent = percent || 0;
    const padding = Math.floor(width * (100 - percent) * .01 / 2);
    ctx.clearRect(0, 0, canvas.width, canvas.height);
    ctx.beginPath();
    ctx.arc(width / 2, height / 2, width / 2, 0, 2 * Math.PI);
    ctx.clip();
    ctx.drawImage(image, width * frame, 0, width, height, padding, padding, Math.floor(width * percent * .01), Math.floor(height * percent * .01));
    return canvas;
  }

  for (let i = 0; i < num_frames; i++) {
    frames.push(create_canvas());
  }

  image.onload = function() {
    for (let i = 0; i < frames.length; i++) {
      frames[i] = draw_frame(frames[i], i);
    }
  };
  image.src = imagesrc;

  this.get_frame = function() {
    return frames[current_frame];
  };
  this.increment_frame = function() {
    current_frame = (current_frame + 1) % num_frames;
  };
}

function load_spritesheet(sheet_url, width, height, percent, frames) {
    const result = new Sprite(sheet_url, width, height , percent, frames);
    all_sprites.push(result);
    return result;
}

setInterval(
  () => all_sprites.forEach((sprite) => sprite.increment_frame()),
  50,
);

export {load_spritesheet, all_sprites};
