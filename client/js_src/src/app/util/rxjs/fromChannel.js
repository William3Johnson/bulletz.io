import {Observable} from 'rxjs';
import {takeUntil} from 'rxjs/operators';

function fromChannel(channel, evt, canceller$) {
  let obs = new Observable((subscriber) => {
    channel.on(evt, (response) => subscriber.next(response))
  });
  if(canceller$) {
    return obs.pipe(takeUntil(canceller$))
  }
  return obs;
}

export {fromChannel}
