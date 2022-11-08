import {load_for_current} from "./routing";
function set_route(path) {
  window.history.pushState(
    {},
    path,
    window.location.origin + path,
  );
  load_for_current();
}

(window as any).set_route = set_route;

export {set_route};
