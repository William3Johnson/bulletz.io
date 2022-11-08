function hide(el: HTMLElement) {
  el.classList.add("hidden");
}

function show(el: HTMLElement) {
  el.classList.remove("hidden");
}

export {hide, show};
