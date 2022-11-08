import {ReplaySubject} from "rxjs";
import {show_error_banner} from "../ui/banner";
import {database} from "./firebase";

const highscores$ = new ReplaySubject(1);

database.collection("highscores").get().then((snapshot) => {
  const highscores = {};
  snapshot.forEach((childSnapshot) => {
    const key = childSnapshot.id;
    const val = childSnapshot.data();
    highscores[key] = val.highscores;
  });
  highscores$.next(highscores);
}).catch((err) => {
  show_error_banner("highscores failed to load");
  console.error(err);
  highscores$.next({});
});

export {highscores$};
