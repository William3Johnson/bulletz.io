# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

config :goth,
  json: "/Users/yeti/workspace/bulletz.io/game_server/prod/gcp/bulletz-io-firebase-adminsdk-2vzvv-a6fe0c432e.json" |> File.read!

config Highscores,
  server_name: "memes",
  max_scores: 10

# This configuration is loaded before any dependency and is restricted
# to this project. If another project depends on this project, this
# file won't be loaded nor affect the parent project. For this reason,
# if you want to provide default values for your application for
# third-party users, it should be done in your "mix.exs" file.

# You can configure your application as:
#
#     config :highscores, key: :value
#
# and access this configuration in your application as:
#
#     Application.get_env(:highscores, :key)
#
# You can also configure a third-party app:
#
#     config :logger, level: :info
#

# It is also possible to import configuration files, relative to this
# directory. For example, you can emulate configuration per environment
# by uncommenting the line below and defining dev.exs, test.exs and such.
# Configuration from the imported file will override the ones defined
# here (which is why it is important to import them last).
#
#     import_config "#{Mix.env()}.exs"
