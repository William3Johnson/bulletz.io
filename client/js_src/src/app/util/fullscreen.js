import {screen_dimensions$} from 'game/graphics/util/screen_dimensions';

function fullscreen(el) {
  screen_dimensions$.subscribe(({width: width, height: height}) => {
    el.width = width;
    el.height = height;
  })
}

export {fullscreen}
