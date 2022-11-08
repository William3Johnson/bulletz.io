import { animationFrameScheduler, BehaviorSubject, combineLatest, from, fromEvent, interval, merge, Observable, ReplaySubject, Subject } from "rxjs";
import { bufferCount, filter, first, last, map, pairwise, repeat, shareReplay, startWith, switchMap, take, takeUntil, tap, timestamp, withLatestFrom } from "rxjs/operators";

import { Channel, Socket } from "phoenix";

import { DesktopMoveRequest, DesktopShootRequest, InputRequest, JoinRequest, MobileMoveRequest, MobileShootRequet } from "game/messages/InputMessage";
import { SyncMessage } from "game/messages/SyncMessage";
import { CreateBullet, CreateFood, CreateMovingFood, CreatePickup, CreatePlayer, RemoveBullet, RemoveFood, RemoveMovingFood, RemovePickup, RemovePlayer, Scoreboard, UpdateMessage } from "game/messages/UpdateMessage";

import { ServerConfig } from "game/config/ServerConfig";

import { Player, State } from "game/state/types";

import { GameEvents } from "game/GameEvents";
import { Renderer } from "game/graphics/Renderer";
import { StateReducer } from "game/state/StateReducer";
import { tick } from "game/state/tick";

import { show_error_banner, show_success_banner } from "ui/banner";

import { display_ping } from "game/hud/ping";
import { update_scoreboard } from "game/hud/scoreboard";
import { update_stats } from "game/hud/stats";
import { Score } from "game/hud/types";

import { mobile } from "util/mobile";

import { calculate_moves, get_dx_dy, get_x_y, prevent_motion, relative_position } from "game/controls/mobile/util";

import { hide, show } from "util/toggle";

import { RenderBox, update_render_box } from "game/graphics/RenderBox";
import { MovementIndicator, ShootIndicator } from "game/graphics/types";

import RateLimiter from "rxjs-ratelimiter";

class Game {

  public game_events: GameEvents;
  public state_reducer: StateReducer;
  public renderer: Renderer;

  public destroy: ReplaySubject<boolean> = new ReplaySubject(1);
  public init: ReplaySubject<boolean> = new ReplaySubject(1);

  public config: ReplaySubject<ServerConfig>;
  public socket: Socket<string>;

  public input: Observable<Channel<string, any, any>>;
  public updates: Observable<Channel<string, void, any>>;
  public sync: Observable<Channel<string, void, SyncMessage>>;
  public time_diff: Observable<number>;
  public ping: Observable<number>;

  public create_bullet: Observable<CreateBullet>;
  public remove_bullet: Observable<RemoveBullet>;

  public active_player: BehaviorSubject<string | null>;
  public game_over: Subject<boolean> = new Subject<boolean>();

  public random_spectate_id: BehaviorSubject<string | null>;
  public player_to_watch: Observable<string | null>;

  public scoreboard: Observable<Scoreboard>;

  public polls: Observable<State>;
  public force_poll: Subject<State>;

  public render_box: BehaviorSubject<RenderBox> = new BehaviorSubject({ x: 0, y: 0, width: window.innerWidth, height: window.innerHeight, scale: 1, initial_state: true });
  public movement_indicator: BehaviorSubject<MovementIndicator> = new BehaviorSubject(null);
  public shoot_indicator: BehaviorSubject<ShootIndicator> = new BehaviorSubject(null);

  constructor(private server: string, private wsprotocol: string) {
    this.config = new ReplaySubject<ServerConfig>(1);

    this.loadConfig();
    this.socket = this.get_socket(server);

    this.input = this.get_channel<InputRequest, any>("input");
    this.updates = this.get_channel<void, UpdateMessage>("updates");
    this.sync = this.get_channel<void, SyncMessage>("sync");

    const ntp_time = ({ before: before, time: server_time, after: after }): number => server_time + ((after - before));

    const raw_time_data = merge(
      this.for_message_type(this.sync, "time"),
      this.push_for_time<void, any>(this.sync, "time").pipe(repeat(3)),
      interval(50).pipe(
        switchMap((_) => this.push_for_time(this.sync, "time")),
        take(25),
      ),
      interval(500).pipe(
        switchMap((_) => this.push_for_time(this.sync, "time")),
      ),
    )
      .pipe(
        map((res) => Object.assign(res, { after: Date.now() })),
        shareReplay(1),
      );

    this.ping = raw_time_data.pipe(
      map(({ before: before, after: after }) => (after - before)),
    );
    this.ping.subscribe((ping) => display_ping(ping));

    this.time_diff = raw_time_data.pipe(
      map((t) => ntp_time(t)),
      map((t) => Math.max(t - Date.now(), 0)),
      takeUntil(this.destroy),
    );

    this.force_poll = new Subject();

    this.polls = merge(
      this.push_for_reply<void, State>(this.updates, "poll"),
      this.for_message_type<State>(this.updates, "poll"),
      this.force_poll,
    ).pipe(shareReplay(1));

    this.scoreboard = this.for_message_type<Scoreboard>(this.updates, "scoreboard");
    this.scoreboard.subscribe(({ scoreboard }) => update_scoreboard(scoreboard));

    this.game_events = {
      create_bullet: this.for_message_type<CreateBullet>(this.updates, "create_bullet"),
      remove_bullet: this.for_message_type<RemoveBullet>(this.updates, "remove_bullet"),

      create_player: this.for_message_type<CreatePlayer>(this.updates, "create_player"),
      remove_player: this.for_message_type<RemovePlayer>(this.updates, "remove_player"),

      create_food: this.for_message_type<CreateFood>(this.updates, "create_food"),
      remove_food: this.for_message_type<RemoveFood>(this.updates, "remove_food"),

      create_moving_food: this.for_message_type<CreateMovingFood>(this.updates, "create_moving_food"),
      remove_moving_food: this.for_message_type<RemoveMovingFood>(this.updates, "remove_moving_food"),

      create_pickup: this.for_message_type<CreatePickup>(this.updates, "create_pickup"),
      remove_pickup: this.for_message_type<RemovePickup>(this.updates, "remove_pickup"),

      poll: this.polls,
    };

    this.state_reducer = new StateReducer(this.game_events);
    this.renderer = new Renderer(this.destroy);

    const frames$ = interval(0, animationFrameScheduler).pipe(
      takeUntil(this.destroy),
      timestamp(),
      map(({ timestamp: timestamp }) => timestamp),
      withLatestFrom(this.time_diff),
      map(([timestamp, time_diff]) => timestamp + time_diff),
      shareReplay(1),
    );

    const framesWithState$ = frames$.pipe(
      withLatestFrom(this.state_reducer.state, this.config),
    );

    this.active_player = new BehaviorSubject(null);
    this.random_spectate_id = new BehaviorSubject(null);

    this.player_to_watch = combineLatest(this.active_player, this.random_spectate_id)
      .pipe(
        map(([player_id, random_id]) => player_id || random_id),
        filter((n) => n != null),
      );

    this.game_events.remove_player
      .pipe(
        map(({ id: id }) => id),
        withLatestFrom(this.random_spectate_id),
        filter(([kill_id, random_spectate_id]) => kill_id == random_spectate_id),
        withLatestFrom(this.state_reducer.state),
        map(([[_, _2], state]) => state.players),
      )
      .subscribe((p) => this.spectate_largest(p));

    this.game_events.remove_player
      .pipe(
        map(({ id: id }) => id),
        withLatestFrom(this.active_player),
        filter(([kill_id, active_player]) => kill_id == active_player),
      )
      .subscribe(() => this.lost());

    this.polls
      .pipe(
        withLatestFrom(this.active_player),
        filter(([state, player_id]) => !Object.hasOwnProperty.call(state, player_id)),
      ).subscribe(([state, player_id]) => {
        if (player_id != null) {
          this.lost();
        }
        this.spectate_largest(state.players);
      });

    merge(
      fromEvent(window, "orientationchange"),
      fromEvent(window, "resize"),
    ).subscribe(() => this.resetRenderBox());
    // TODO: make this update instantly on device orientation change/window resize.

    framesWithState$
      .pipe(
        map(([current_time, state, config]) => tick(state, current_time, config)),
        tap((state) => this.state_reducer.state.next(state)),
        withLatestFrom(this.player_to_watch, this.render_box, this.active_player, this.movement_indicator, this.shoot_indicator, this.config),
      )
      .subscribe(([state, player, render_box, active_player, movement_indicator, shoot_indicator, config]) => {
        if (Object.hasOwnProperty.call(state.players, player)) {
          render_box = update_render_box(render_box, state.players[player], config);
          this.render_box.next(render_box);
        }
        if (Object.hasOwnProperty.call(state.players, active_player)) {
          update_stats(state.players[active_player]);
        } else {
          update_stats(null);
        }
        this.renderer.render(state, render_box, active_player, movement_indicator, shoot_indicator, config);
      });

    framesWithState$
      .pipe(first())
      .subscribe(() => this.init.next(true));
  }

  public spectate_largest(players) {
    const ids = Object.keys(players);
    if (ids.length == 0) {
      return;
    }

    this.random_spectate_id.next(ids.sort((a, b) => players[b].radius - players[a].radius)[0]);
  }

  public loadConfig(): void {
    let destroyed = false;
    let timeout = null;
    this.destroy.subscribe(() => {
      destroyed = true;
      if (timeout !== null) {
        clearTimeout(timeout);
      }
    });
    fetch("//" + this.server + "/config")
      .then((response) => response.json())
      .then((json) => (json as ServerConfig))
      .then((cfg) => this.config.next(cfg))
      .catch((e) => {
        console.error(e);
        show_error_banner("Failed to fetch config from server", { log: false });
        if (!destroyed) {
          timeout = setTimeout(() => this.loadConfig(), 5000);
        }
      });
  }

  public tear_down(): void {
    this.destroy.next(true);
    this.config.complete();
    this.active_player.complete();
    this.random_spectate_id.complete();
    this.force_poll.complete();
  }

  public get_socket(url): Socket<string> {
    const protocol: string = this.wsprotocol;
    const socket = new Socket<string>(protocol + "://" + url + "/socket");

    socket.connect();
    this.destroy.subscribe(() => {
      console.log("Disconnecting socket");
      socket.disconnect();
    });

    const handleSocketReconnect = this.handleSocketReconnect.bind(this);
    socket.onOpen(() => {
      if (socket.firstConnectionDone) {
        console.info("Socket reconnected");
        show_success_banner("Reconnected");
        console.info("Fetching initial state");
        handleSocketReconnect();
      }

      socket.firstConnectionDone = true;
    });

    let error_showing = false;
    socket.onError((e) => {
      socket.firstConnectionDone = true;
      console.error(e);
      if (!error_showing) {
        show_error_banner("websocket connection error");
      }
      error_showing = true;
      setTimeout(() => { error_showing = false; }, 5000);
    });

    console.info(`Websocket connection establed to ${protocol + url + "/socket"}`);
    return socket;
  }

  public get_channel<InputType, ResponseType>(channel_name): Observable<Channel<string, InputType, ResponseType>> {
    const channel = this.socket.channel<InputType, ResponseType>(channel_name);
    this.destroy.subscribe(
      () => channel.leave(),
    );

    return from(new Promise<Channel<string, InputType, ResponseType>>((resolve, reject) => {
      channel.join()
        .receive("ok", (response) => {
          console.info(`joined channel ${channel_name}`);
          resolve(channel);
        })
        .receive("error", (e) => {
          show_error_banner(`failed to join channel ${channel_name}`);
        });
    }))
      .pipe(shareReplay(1));
  }

  public for_message_type<T>(channelObservable: Observable<Channel<string, any, any>>, evt: string): Observable<T> {
    return channelObservable.pipe(switchMap(
      (channel) => new Observable<T>((subscriber) => {
        channel.on(evt, (response) => subscriber.next(response as T));
      }),
    ))
      .pipe(shareReplay(1));
  }

  public push_for_time<Payload, ReplyType>(channelObservable: Observable<Channel<string, Payload, ReplyType>>, evt: string, payload?: Payload): Observable<ReplyType> {
    const t = Date.now();
    return channelObservable.pipe(switchMap(
      (channel) => new Observable<ReplyType>((subscriber) => {
        channel.push(evt, payload)
          .receive("ok", (response) => subscriber.next(Object.assign({ before: t }, response)))
          .receive("error", (err) => show_error_banner(err));
      }),
    ))
      .pipe(
        first(),
      );
  }

  public push_for_reply<Payload, ReplyType>(channelObservable: Observable<Channel<string, Payload, ReplyType>>, evt: string, payload?: Payload): Observable<ReplyType> {
    return channelObservable.pipe(switchMap(
      (channel) => new Observable<ReplyType>((subscriber) => {
        channel.push(evt, payload)
          .receive("ok", (response) => subscriber.next(response))
          .receive("error", (err) => show_error_banner(err));
      }),
    ))
      .pipe(
        first(),
      );
  }

  public resetRenderBox() {
    this.render_box.next({ x: 0, y: 0, width: window.innerWidth, height: window.innerHeight, scale: 1, initial_state: true });
  }

  public lost() {
    this.game_over.next(true);
    Array.prototype.map.call(document.querySelectorAll(".mobile_control"), (el) => {
      hide(el);
    });
    setTimeout(() => {
      this.active_player.next(null);
    }, 1800);
  }

  public handleSocketReconnect() {
    this.push_for_reply<void, State>(this.updates, "poll")
      .subscribe((poll) => {
        this.force_poll.next(poll);
      });

    this.loadConfig();
  }

  public join(name, mobile) {
    this.push_for_reply<JoinRequest, any>(this.input, "join", { name, mobile }).subscribe((player) => {
      this.active_player.next(player.id);
      if (mobile) {
        Array.prototype.map.call(document.querySelectorAll(".mobile_control"), (el) => {
          show(el);
        });
        this.create_mobile_controls();
      }
      // for now lets create desktop controls always
      this.create_desktop_controls();
    });
  }

  public create_mobile_controls() {
    this.stop_mobile_scrolls();
    this.create_mobile_movement_control();
    this.create_mobile_shoot_control();
  }

  public create_mobile_movement_control() {
    const movement_controller: HTMLElement = document.getElementById("movement_controller");
    const movement_indicator: HTMLElement = document.getElementById("movement_indicator");

    const touchstart =
      fromEvent(movement_controller, "touchstart", { passive: false })
        .pipe(
          takeUntil(this.game_over),
          tap(prevent_motion),
          map(get_x_y),
        );

    const touchmove = fromEvent(movement_controller, "touchmove", { passive: false })
      .pipe(
        takeUntil(this.game_over),
        tap(prevent_motion),
        map(get_x_y),
      );

    const touchend = fromEvent(movement_controller, "touchend", { passive: false })
      .pipe(
        takeUntil(this.game_over),
      );

    fromEvent(movement_controller, "touchstart", { passive: true })
      .pipe(takeUntil(this.game_over))
      .pipe(first())
      .subscribe(() => hide(movement_indicator));

    const rate_limiter: RateLimiter = new RateLimiter(1, 130);

    touchstart.subscribe(
      ({ x: start_x, y: start_y }) => {
        const dx_dy = touchmove.pipe(
          takeUntil(touchend),
          takeUntil(this.game_over),
          map(({ x: x, y: y }) => get_dx_dy(x, y, start_x, start_y)),
        );
        dx_dy.subscribe((v) => this.movement_indicator.next(v));

        rate_limiter.limit(
          dx_dy,
        ).subscribe(({ dx: x, dy: y }) => {
          if (x != 0 || y != 0) {
            const body = calculate_moves({ x, y });
            this.push_for_reply<MobileMoveRequest, unknown>(this.input, "mobile_movement", body).subscribe(
              (res) => null,
              (err) => { show_error_banner(err); this.lost(); },
            );
          }
        });
      },
    );

  }

  public create_mobile_shoot_control() {
    const shoot_dial = document.getElementById("shoot_dial");
    const shoot_controller = document.getElementById("shoot_controller");

    const max_move = 100;
    const max_visible_move = 20;

    const touchstart = merge(
      fromEvent(shoot_controller, "touchstart", { passive: false }),
      fromEvent(shoot_dial, "touchstart", { passive: false }),
    ).pipe(
      takeUntil(this.game_over),
      tap(prevent_motion),
      map(get_x_y),
    );

    const touchmove = merge(
      fromEvent(shoot_controller, "touchmove", { passive: false }),
      fromEvent(shoot_dial, "touchmove", { passive: false }),
    ).pipe(
      takeUntil(this.game_over),
      tap(prevent_motion),
      map(get_x_y),
    );

    const touchend = merge(
      fromEvent(shoot_controller, "touchend", { passive: false }),
      fromEvent(shoot_dial, "touchend", { passive: false }),
    ).pipe(
      takeUntil(this.game_over),
    );

    const rate_limiter: RateLimiter = new RateLimiter(1, 150);

    touchstart.subscribe(
      ({ x: start_x, y: start_y }) => {
        const dx_dy = touchmove
          .pipe(
            takeUntil(touchend),
            map(({ x: x, y: y }) => get_dx_dy(x, y, start_x, start_y)),
          );

        dx_dy.subscribe((v) => this.shoot_indicator.next(v));

        rate_limiter.limit(dx_dy)
          .subscribe(({ dx: dx, dy: dy }) => {
            if (dx != 0 || dy != 0) {
              this.push_for_reply<MobileShootRequet, unknown>(this.input, "shoot", { x: dx, y: dy }).subscribe(
                (res) => null,
                (err) => { show_error_banner(err); this.lost(); },
              );
            }
          });
      },
    );

    const movedial =
      touchmove
        .pipe(
          takeUntil(this.game_over),
          withLatestFrom(touchstart),
          map(([{ x: x, y: y }, { x: start_x, y: start_y }]) => get_dx_dy(x, y, start_x, start_y)),
        );

    movedial.subscribe(
      ({ dx: dx, dy: dy }) => {
        if (dx > max_visible_move) {
          dx = max_visible_move;
        }
        if (dx < -max_visible_move) {
          dx = -max_visible_move;
        }
        if (dy > max_visible_move) {
          dy = max_visible_move;
        }
        if (dy < -max_visible_move) {
          dy = -max_visible_move;
        }
        shoot_dial.style.transform = "translate(" + dx + "px," + dy + "px)";
      },
    );
  }

  public stop_mobile_scrolls() {
    const movement_controller: HTMLElement = document.getElementById("movement_controller");
    const movement_indicator: HTMLElement = document.getElementById("movement_indicator");
    const shoot_dial = document.getElementById("shoot_dial");
    const shoot_controller = document.getElementById("shoot_controller");

    merge(
      fromEvent(movement_controller, "scroll", { passive: false }),
      fromEvent(movement_controller, "touchmove", { passive: false }),
      fromEvent(movement_indicator, "scroll", { passive: false }),
      fromEvent(movement_indicator, "touchmove", { passive: false }),
      fromEvent(shoot_dial, "scroll", { passive: false }),
      fromEvent(shoot_dial, "touchmove", { passive: false }),
      fromEvent(shoot_controller, "scroll", { passive: false }),
      fromEvent(shoot_controller, "touchmove", { passive: false }),
    ).pipe(takeUntil(this.game_over)).subscribe(prevent_motion);

  }

  public create_desktop_controls() {
    const controls = {
      w: "up",
      a: "left",
      s: "down",
      d: "right",
      arrowup: "up",
      arrowdown: "down",
      arrowleft: "left",
      arrowright: "right",
    };

    // TODO instant feedback on player state

    fromEvent<KeyboardEvent>(window, "keydown", { passive: false })
      .pipe(
        takeUntil(this.game_over),
        filter((e) => controls.hasOwnProperty(e.key.toLowerCase())),
        tap((e) => e.preventDefault()),
        map((e) => e.key.toLowerCase()),
      ).subscribe((key) => {
        this.push_for_reply<DesktopMoveRequest, void>(this.input, "down", { action: controls[key] })
          .subscribe(
            (res) => null,
            (err) => { show_error_banner(err); this.lost(); },
          );
      });

    fromEvent<KeyboardEvent>(window, "keyup", { passive: false })
      .pipe(
        takeUntil(this.game_over),
        filter((e) => controls.hasOwnProperty(e.key.toLowerCase())),
        tap((e) => e.preventDefault()),
        map((e) => e.key.toLowerCase()),
      ).subscribe((key) => {
        this.push_for_reply<DesktopMoveRequest, void>(this.input, "up", { action: controls[key] })
          .subscribe(
            (res) => null,
            (err) => { show_error_banner(err); this.lost(); },
          );
      });

    interval(100)
      .pipe(
        takeUntil(this.game_over),
        filter((_) => !mobile()),
        switchMap((_) => this.render_box),
        withLatestFrom(fromEvent<MouseEvent>(document, "mousemove", { passive: true })),
      )
      .subscribe(([render_box, e]) => {
        const x = e.pageX * render_box.scale + render_box.x;
        const y = e.pageY * render_box.scale + render_box.y;
        this.push_for_reply<DesktopShootRequest, void>(this.input, "shoot", { x, y })
          .subscribe(
            (res) => null,
            (err) => { show_error_banner(err); this.lost(); },
          );
      });
  }

}

export { Game };
