docker-up:
		$(DOCKER) compose -p $(PROJECT) --env-file $(CONFIG)/.env.docker -f $(CONFIG)/compose.yaml up -d

docker-down:
		$(DOCKER) compose -p $(PROJECT) -f $(CONFIG)/compose.yaml down

docker-build:
		$(DOCKER) build -t $(USER)/$(PROJECT):$(VERSION) .

docker-run:
		$(DOCKER) container run --name $(PROJECT) -it  $(USER)/$(PROJECT):$(VERSION) /bin/bash

# docker-gh-test:
# 		$(DOCKER) container run --name $(PROJECT) -p 3000:3000 --rm $(USER)/$(PROJECT):$(VERSION)

# docker-gh-pull:
# 		$(DOCKER) pull ghcr.io/mohsenhariri/template-go:release 

# docker-gh-run:
# 		$(DOCKER) run -p 3000:3000 -it --rm ghcr.io/mohsenhariri/template-go:release

docker-postgres:
		docker run -d \
		--name ${PROJECT}-postgres \
		-e POSTGRES_USER=${POSTGRES_USER} \
		-e POSTGRES_PASSWORD=${POSTGRES_PASSWORD} \
		-e POSTGRES_DB=${POSTGRES_DB} \
		-p ${PORT_POSTGRES}:5432 \
		-v ./${CONFIG}/volumes/postgres:/var/lib/postgresql/data \
		postgres

docker-redis:
		docker run -d \
		--name ${PROJECT}-redis \
		-p ${PORT_REDIS}:6379 \
		redis

docker-init: docker-postgres docker-redis
