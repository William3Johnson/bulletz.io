function capitalizeFirstLetter(string) {
    return string.charAt(0).toUpperCase() + string.slice(1);
}

function get_scoreboard_item({name: name, color: color, score: score}) {
  name = capitalizeFirstLetter(name);
  return `<li class="stat-font" style="color:${color}">${name}: <span class="score">${Math.floor(score)}</span></li>`;
}

function update_scoreboard(scoreboard) {
    const scoreboard_div = document.getElementById("scoreboard");
    const list_items = scoreboard.map(get_scoreboard_item);
    scoreboard_div.innerHTML = list_items.join("");
}

export {update_scoreboard};
