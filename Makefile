NAME := docker-shipit-engine
DOCKER_ORG := digitalocean
GITCOMMIT := $(shell git rev-parse --short HEAD 2>/dev/null)

BASE_IMAGE_URL := $(DOCKER_ORG)/$(NAME)
IMAGE_URL := $(BASE_IMAGE_URL):$(GITCOMMIT)

build:
	docker build --pull -t ${IMAGE_URL} .

shell:
	docker-compose exec app sh

start:
	docker-compose up --build -d && docker-compose logs -f

stop:
	docker-compose down

setup:
	docker-compose run app setup

upgrade:
	docker-compose run app upgrade
