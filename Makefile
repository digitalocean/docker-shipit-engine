NAME := docker-shipit-engine
DOCKER_ORG := digitalocean
GITCOMMIT := $(shell git rev-parse --short HEAD 2>/dev/null)

BASE_IMAGE_URL := $(DOCKER_ORG)/$(NAME)
IMAGE_URL := $(BASE_IMAGE_URL):$(GITCOMMIT)

image-build:
	docker build --pull -t ${IMAGE_URL} .

shell:
	docker-compose exec app sh

start-local:
	docker-compose up --build -d && docker-compose logs -f

stop-local:
	docker-compose down
