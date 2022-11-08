import {Route} from "routing/Route.ts";
import {set_route} from "routing/set_route";

const world_select = new Route(
    /\/world_select/,
    require("routing/routes/world_select/world_select.html"),
    init_world_select,
    () => null,
);

function init_world_select(params) {
}

export {world_select};
