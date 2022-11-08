use Mix.Config

#PHOENIX
# Configures the endpoint
config :socket_server, SocketServer.Endpoint,
  server: true,
  url: [host: "localhost"],
  port: 8000,
  secret_key_base: "fjGXXY2usmVRV9iIvVbXHISD0b4ZHaAK3pZ96LrBStNyS933ghZfRDRMvFSGVjLv",
  render_errors: [view: SocketServer.ErrorView, accepts: ~w(html json)],
  pubsub: [name: SocketServer.PubSub,
           adapter: Phoenix.PubSub.PG2]

config :powerups,
 powers: :all

# Configures Elixir's Logger
config :logger,
  backends: [:console],
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id],
  level: :info
  
# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
import_config "#{Mix.env}.secret.exs"

extra_config = System.get_env("THEME")
if extra_config != nil do
  import_config "worlds/#{extra_config}.exs"
end
# Must configure gringotts
#config :gringotts, Gringotts.Gateways.Monei,
#    userId: "your_secret_user_id",
#    password: "your_secret_password",
#    entityId: "your_secret_channel_id"
