import {Route} from "routing/Route.ts";
import {set_route} from "routing/set_route";

const splash = new Route(
    /\/$/,
    require("routing/routes/splash/splash.html"),
    init_splash,
    () => null,
);

function init_splash(params) {
  document.getElementById("enter-world-select").addEventListener("click", () => {
    set_route(`/play?server=${(window as any).game_server}`);
  });
}

export {splash};
