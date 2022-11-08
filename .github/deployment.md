
# Deployment

Some information about deployments:

## Secrets

To run the highscores,
you'll need to save a firebase admin SDK for the bulletz.io project to:

`game_server/prod/gcp/bulletz-io-firebase-adminsdk.json`

This file is intentionally excluded from the repo for security reasons.  You
probably won't be able to replicate it, but you can ask me to deploy server
updates for you.

Make sure to uncomment:
```
use Mix.Config
config :goth,
  json: "/Users/yeti/workspace/bulletz.io/game_server/prod/gcp/bulletz-io-firebase-adminsdk.json" |> File.read!
```

from `game_server/game_config/config/dev.secret.exs`.

## Makefile

The [Makefile](Makefile) holds all of the deployment tasks.

## Deploying Frontend

The static content can be deployed to any static content server.
Running `hugo` builds the client into the `public` directory.
This should take under a second.
You might need to trigger a new webpack build.
The deploy script is for deploying to github pages which is where bulletz is currently hosted.

`make build-client deploy-client`

## Docker Containers

`make build-dockerized-builder`

There are two docker containers: the builder, which is hosted under
`game_server/docker/builder/` and is responsible for building the server, and
the runtime container, which is hosted at `game_server/docker/runtime/`.
