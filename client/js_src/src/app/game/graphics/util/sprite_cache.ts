import {load_spritesheet} from "./spritesheet";

const cache = Object.create(null);

function inner_load_sprite(path, listener) {
  const sprite = new Image();
  sprite.addEventListener("error", listener);
  sprite.src = path;
  return sprite;
}

function load_sprite(path) {
  cache[path] = inner_load_sprite(path, () => {
    setTimeout(
      () => cache[path] = load_sprite(path),
      1000,
    );

  });
}

function get_spritesheet(path, width, height, percent, num_frames) {
  if (path in cache) {
    return cache[path];
  }
  cache[path] = load_spritesheet(path, width, height, percent, num_frames);
  return cache[path];
}

function clear_cache(name) {
  delete cache[name];
}

function get_sprite(path) {
  if (path in cache) {
    return cache[path];
  }
  load_sprite(path);
  return cache[path];
}

export { get_sprite, get_spritesheet };
