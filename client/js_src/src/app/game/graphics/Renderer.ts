import {animationFrameScheduler, fromEvent, interval, merge, Observable, ReplaySubject, Subject} from "rxjs";
import {takeUntil, withLatestFrom} from "rxjs/operators";

import {ServerConfig} from "game/config/ServerConfig";
import {RenderBox} from "game/graphics/RenderBox";
import {MovementIndicator, ShootIndicator} from "game/graphics/types";
import {State} from "game/state/types";

import {draw} from "game/graphics/draw";

export class Renderer {

  private canvas: HTMLCanvasElement;
  private context: CanvasRenderingContext2D;

  constructor(
    private destroy: ReplaySubject<boolean>) {
    this.canvas = this.setupCanvas();
    this.context = this.canvas.getContext("2d");
  }

  public render(state: State, renderBox: RenderBox, active_player: string | null, movement_indicator: MovementIndicator, shoot_indicator: ShootIndicator, config: ServerConfig) {
    draw(this.canvas, this.context, state, renderBox, active_player, movement_indicator, shoot_indicator, config);
  }

  public setupCanvas(): HTMLCanvasElement {
    const canvas = document.getElementById("game") as HTMLCanvasElement;

    merge(fromEvent(window, "resize"), fromEvent(window, "orientationchange"))
      .pipe(takeUntil(this.destroy))
      .subscribe(() => {
        canvas.width = Math.max(document.documentElement.clientWidth, window.innerWidth || 0);
        canvas.height = Math.max(document.documentElement.clientHeight, window.innerHeight || 0);
      });

    canvas.width = Math.max(document.documentElement.clientWidth, window.innerWidth || 0);
    canvas.height = Math.max(document.documentElement.clientHeight, window.innerHeight || 0);

    return canvas;
  }

}
