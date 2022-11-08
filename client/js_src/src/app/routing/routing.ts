import {Route} from "routing/Route.ts";
import {show_error_banner} from "ui/banner";
import {pathname, queryParams} from "./path";

import {game} from "routing/routes/game/game.ts";
import {spectate} from "routing/routes/spectate/spectate.ts";
import {splash} from "routing/routes/splash/splash.ts";
import {world_select} from "routing/routes/world_select/world_select.ts";
import {Observable} from "rxjs";

import {set_route} from "routing/set_route";

const routerRoot = document.getElementById("router-root");

const routes: Route[] = [
  world_select,
  game,
  spectate,
  splash,
];

let prev_route: Route;

function load_for_current() {
  if (prev_route != null ) {
    prev_route.destroy(prev_route.getState());
  }

  try {
    const currentRoute = find_current_route(pathname());
    const routeParams = currentRoute.parseParams();

    routerRoot.innerHTML = currentRoute.content;
    currentRoute.setState(currentRoute.mount(routeParams));
  } catch (e) {
    show_error_banner(e);
  }
}

function find_current_route(currentPathname): Route {
  const currentRoute = routes.find((route) => currentPathname.match(route.pathname));
  if (currentRoute == null) {
    throw new Error("no matching route");
  }
  return currentRoute;
}

function zero_state() {
  window.history.replaceState(
    {},
    "/",
    window.location.origin,
  );
  load_for_current();
}

function setup_routing() {
  window.addEventListener("popstate", load_for_current);
  load_for_current();
}

export { setup_routing, load_for_current};
