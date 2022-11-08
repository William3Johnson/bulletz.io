import {fromEvent} from "rxjs";
import {Observable} from "rxjs";
import {takeUntil} from "rxjs/operators";

import {Route} from "routing/Route.ts";
import {RouteParams} from "routing/RouteParams.ts";

import {set_route} from "routing/set_route";
import {mobile} from "util/mobile";

import {Game} from "game/Game";
import {highscores$} from "../../../util/highscores";

const game = new Route(
    /\/play/,
    require("routing/routes/game/game.html"),
    init_game,
    (game: Game) => game.tear_down(),
    new RouteParams(["server"], ["wsprotocol"]),
);

function create_td(text) {
    const td = document.createElement("td");
    td.classList.add("white");
    td.appendChild(document.createTextNode(text));
    return td;
}

function create_score_entry(entity) {
  const {rank, score, name} = entity;
  const tr = document.createElement("tr");

  tr.appendChild(create_td(rank));
  tr.appendChild(create_td(score));
  tr.appendChild(create_td(name));
  return tr;
}

function create_highscores(score_entries, scores) {
  score_entries.innerHTML = "";
  scores.sort((a, b) => a.rank > b.rank ? 1 : -1).map(create_score_entry).forEach((entry) => {
    score_entries.appendChild(entry);
  });
}

function init_game(params): any {
  const server = params.server;
  const wsprotocol = params.wsprotocol ||
    (window.location.hostname == "localhost" ? "ws" : "wss");
  const game = new Game(server, wsprotocol);

  game.init.subscribe(() => {
    const overlay = document.getElementById("game-overlay");
    const joinOverlay = document.getElementById("join-overlay");
    const loadingOverlay = document.getElementById("load-ad-overlay");
    const score_entries = document.getElementById("score-entries");

    highscores$.subscribe((v: any) => {
      if (v.memes) {
        create_highscores(score_entries, v.memes);
      }
    });

    game.active_player.subscribe((player) => {
        if (player !== null) {
          overlay.classList.add("hidden");
          loadingOverlay.classList.add("hidden");
          joinOverlay.classList.add("hidden");
        } else {
          overlay.classList.remove("hidden");
        }
      });

    // Note to self: uncomment to re-enable ads

    const join = document.getElementById("join");
    join.addEventListener("click", () => {
        joinOverlay.classList.add("hidden");
        game.join(name_input.value, mobile());
      });

    document.getElementById("play").addEventListener("click", (e) => {
      overlay.classList.add("hidden");
      loadingOverlay.classList.add("hidden");
      joinOverlay.classList.add("hidden");
      game.join(name_input.value, mobile());
      /*
        overlay.classList.add("hidden");
        loadingOverlay.classList.remove("hidden");
        showAd(() => {
          loadingOverlay.classList.add("hidden");
          joinOverlay.classList.remove("hidden");
        });
        */

      });
  });

  const name_input = document.getElementById("name-input") as HTMLInputElement;
  if ("localStorage" in window) {
    name_input.value = window.localStorage.getItem("username");
  }
  fromEvent(name_input, "input", {passive: true})
    .pipe(takeUntil(game.destroy))
    .subscribe(() => {
      if ("localStorage" in window) {
        window.localStorage.setItem("username", name_input.value);
      }
    });
  return game;
}

export {game};
