all: deploy-client build-dockerized-server

build-client:
	rm -rf client/public
	cd client && hugo

deploy-client: build-client
	git add -f client/public
	git commit -m "TEMP COMMIT WILL REMOVE" || true
	git subtree split --prefix client/public -b gh-pages
	git push -f origin gh-pages:gh-pages
	git branch -D gh-pages

build-dockerized-builder:
	cd game_server && docker build -f docker/builder/Dockerfile . -t bulletz_builder

build-server: build-dockerized-builder
	rm -rf game_server/socket_server/_build
	cd game_server/socket_server && MIX_ENV=ci mix deps.get
	docker run \
	 --mount type=bind,source=$(shell pwd)/game_server,target=/workspace/bulletz \
	  bulletz_builder:latest \
	  /bin/bash \
	  /run.sh

build-dockerized-server: build-server
	cd game_server && docker build . -f docker/runtime/Dockerfile -t lukewood/bulletz

# TODO(lukewood) deploy-dockerized-server -- will deploy to kubernetes cluster

BULLETZ_BIN=/bulletz/_build/prod/rel/socket_server/bin/socket_server
deploy-raw-server:
	ssh -i $(HOME)/.ssh/id_rsa root@$(HOST) "$(BULLETZ_BIN) stop || true"
	rsync -e "ssh -i $(HOME)/.ssh/id_rsa" -aH game_server/socket_server/_build root@$(HOST):/bulletz --delete
	rsync -e "ssh -i $(HOME)/.ssh/id_rsa" -aH game_server/prod root@$(HOST):/bulletz --delete
	ssh -i $(HOME)/.ssh/id_rsa root@$(HOST) "$(BULLETZ_BIN) daemon_iex"

remote-server-session:
ifndef HOST
	$(error HOST is not set)
endif
	ssh -i $(HOME)/.ssh/id_rsa root@$(HOST) "$(BULLETZ_BIN) remote"

dev-server:
	tmux new-session -s dev -d
	tmux send-keys -t dev "cd client && hugo server -D --disableFastRender" Enter
	tmux new-window -t dev
	tmux send-keys -t dev:2 "cd client/js_src && npm run watch" Enter
	tmux new-window -t dev
	tmux send-keys -t dev: "cd game_server/socket_server && iex -S mix" Enter
	tmux attach -t dev
