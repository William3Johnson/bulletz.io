const Toastify = require("toastify-js");

function show_banner(banner) {
  Toastify(banner).showToast();
}

function show_error_banner(text, opts?) {
  if (typeof text == "object") {
    text = JSON.stringify(text);
  }
  if (!(opts && opts.disable_log)) {
    console.error(text);
  }
  Toastify(
    {
      text,
      close: true,
      timeout: 5000,
      backgroundColor: "linear-gradient(to right, #ff5f6d, #ffc371)",
    },
  ).showToast();
}

export function show_success_banner(text) {
  Toastify(
    {
      text,
      close: true,
      timeout: 2500,
      backgroundColor: "linear-gradient(to right, #00b09b, #96c93d)",
    },
  ).showToast();
}

export {show_banner, show_error_banner};
