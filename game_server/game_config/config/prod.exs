use Mix.Config

config :socket_server, SocketServer.Endpoint,
  load_from_system_env: false,
  code_reloader: false,
  http: [:inet6, port: 8000],
  server: true,
	check_origin: [
    "http://localhost:1313",
    "http://bulletz.io",
    "https://bulletz.io",
    "//bulletz.io",
    "https://server.bulletz.io",
    "https://server.bulletz.io",
    "//server.bulletz.io",
    "//*.bulletz.io",
    "//bulletz-io.lit.games",
    "//bulletz-server.lit.games",
    "//bulletz.lit.games"
    ],
  version: Mix.Project.config[:version]

# Do not print debug messages in production
config :logger, level: :info

config :goth,
  json: "/bulletz/prod/gcp/bulletz-io-firebase-adminsdk-2vzvv-a6fe0c432e.json" |> File.read!

config :world,
  max_players: 25

config :highscores,
  server_name: "memes",
  enabled: true,
  max_scores: 10
