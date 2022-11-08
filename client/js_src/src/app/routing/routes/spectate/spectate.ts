import {Route} from "routing/Route.ts";
import {RouteParams} from "routing/RouteParams.ts";

import {set_route} from "routing/set_route";

import {Game} from "game/Game";

const spectate = new Route(
    /\/watch/,
    require("routing/routes/spectate/spectate.html"),
    init_spectate,
    (game: Game) => game.tear_down(),
    new RouteParams(["server"], ["wsprotocol"]),
);

function init_spectate(params) {
  const server = params.server;
  const wsprotocol = params.wsprotocol || "wss";
  const game = new Game(server, wsprotocol);
}

export {spectate};
