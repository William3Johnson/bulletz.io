import {Subject} from 'rxjs'

let queuedCallbacks = [];

(window).SDK_OPTIONS = {
   gameId: "phcitenjywchsvosvr1wqn27hcb57r5w",
   onEvent: function(a) {
      switch (a.name) {
         case "SDK_GAME_PAUSE":
            // pause game logic / mute audio
            break;
         case "SDK_GAME_START":
            processCallbacks()
            // advertisement done, resume game logic and unmute audio
            break;
         case "SDK_READY":
            // when sdk is ready
            break;
      }
   },
};

function processCallbacks() {
  for (let cb of queuedCallbacks) {
    cb();
  }
  queuedCallbacks = [];
}

export function showAd(cb) {
  const sdk = (window).sdk;
  queuedCallbacks.push(cb);
  if (typeof sdk !== "undefined" && sdk.showBanner !== "undefined") {
    sdk.showBanner()
  } else {
    console.error("SDK not defined");
  }
}

(function(a, b, c) {
const d = a.getElementsByTagName(b)[0];
a.getElementById(c) || (a = a.createElement(b), a.id = c, a.src = "https://api.gamemonetize.com/sdk.js", d.parentNode.insertBefore(a, d));
})(document, "script", "gamemonetize-sdk");
