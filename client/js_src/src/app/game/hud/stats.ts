import {Player} from "game/state/types";

function capitalizeFirstLetter(string) {
    if (typeof string !== "string") {
      return string;
    }
    return string.charAt(0).toUpperCase() + string.slice(1);
}

function isPlayer(player: any): player is Player {
  return "id" in player;
}

export function update_stats(player: Player | void) {
  const player_stats = document.getElementById("player-stats");

  if (player == null) {
    player_stats.innerHTML = "";
    return;
  } else if (isPlayer(player)) {
    const score = Math.floor(player.radius);
    const min_score = Math.floor(player.radius - player.min_radius);
    const html_string = `<div id="stat-radius" style="color:${player.color}">Radius:${score}</div><div id="health" style="color:${player.color}">Health:${min_score}</div>`;

    if (html_string != player_stats.innerHTML) {
      player_stats.innerHTML = html_string;
    }
  }
}
