export function elapsed_ticks(current_time: number, last_time: number, interval: number) {
  if (arguments.length != 3) {
    throw new Error(("WRONG ARGS"));
  }
  const dt = current_time - last_time;
  const ticks = dt / interval;
  return Math.max(ticks, 0);
}
