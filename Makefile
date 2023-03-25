# https://www.gnu.org/software/make/manual/make.html
include .env
export

include *.make

PATH := $(HOME)/go/bin:$(PATH)

ifneq ("$(wildcard /usr/local/go/bin/go)","")
    GO := /usr/local/go/bin/go
else
    GO := $(HOME)/compiler/go/1191/go/bin/go 
endif

DOCKER := /usr/bin/docker 
CURL := /usr/bin/curl

SRC := src
DIST := dist
BUILD := bin

.PHONY: env test all dev clean dev $(SRC) $(DIST) $(BUILD)

ifeq ($(SSL), true)
PROTOCOL := HTTPS
else
PROTOCOL := HTTP
endif
URL := $(PROTOCOL)://$(HOST):$(PORT)

.ONESHELL:

%: # https://www.gnu.org/software/make/manual/make.html#Automatic-Variables 
		@:
		
cert: # HTTPS server
		if [ ! -d "./certs" ]; then mkdir ./certs; fi
		if [ -f "./certs/openssl.conf" ] ; then \
		openssl req -x509 -new -config ./certs/openssl.conf -out ./certs/cert.pem -keyout ./certs/key.pem ;  else \
		openssl req -x509 -nodes -newkey rsa:4096 -out ./certs/cert.pem -keyout ./certs/key.pem -sha256 -days 365 ;fi

init-db-postgres:
		docker run -d \
		--name ${PROJECT}-postgres \
		-e POSTGRES_USER=user \
		-e POSTGRES_PASSWORD=123 \
		-e POSTGRES_DB=pdb \
		-p ${PORT_POSTGRES}:5432 \
		-v $(HOME)/github/serv-auth/config/volumes/postgres:/var/lib/postgresql/data \
		postgres

init-db-redis:
		docker run -d \
		--name ${PROJECT}-redis \
		-p ${PORT_REDIS}:6379 \
		redis

init: init-db-postgres init-db-redis

docker-up:
		docker compose -p $(PROJECT) --env-file ./config/.env.docker -f ./config/compose.yaml up -d

docker-down:
		docker compose -p $(PROJECT) -f ./config/compose.yaml down

docker-build:
		docker build -t $(USER)/$(PROJECT):$(VERSION) .

docker-run:
		 docker container run --name $(PROJECT) -it  $(USER)/$(PROJECT):$(VERSION) /bin/bash


g-commit: go-tidy
		git commit -m "$(filter-out $@,$(MAKECMDGOALS))"

g-log:
		git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit

test:
		$(DOCKER) version
		$(GO) version
		$(CURL) --version

dev:
		CompileDaemon  --command=./serv-auth -verbose --color -exclude-dir=config -exclude-dir=.git
		rm serv-auth

all: test build

go-init:
		$(GO) mod init github.com/mohsenhariri/$(PROJECT)

go-get:
		$(GO) get  $(filter-out $@,$(MAKECMDGOALS))

go-tidy:
		$(GO) mod tidy

go-run:
		$(GO) run main.go

go-build:
		$(GO) build -o $(BUILD)/main main.go

go-run-bin:
		$(BUILD)/main

# https://gist.github.com/asukakenji/f15ba7e588ac42795f421b48b8aede63
go-compile:
		@echo "Compiling for every OS and Platform"
		GOOS=linux GOARCH=arm go build -o bin/main-linux-arm main.go
		GOOS=linux GOARCH=arm64 go build -o bin/main-linux-arm64 main.go
		GOOS=freebsd GOARCH=386 go build -o bin/main-freebsd-386 main.go
		GOOS=windows GOARCH=386 go build -o bin/main-windows-386 main.go