NAME := docker-shipit-engine
DOCKER_ORG := digitalocean
GITCOMMIT := $(shell git rev-parse --short=10 HEAD 2>/dev/null)

BASE_IMAGE_URL := $(DOCKER_ORG)/$(NAME)
IMAGE_URL := $(BASE_IMAGE_URL):$(GITCOMMIT)

image-create:
	docker build --pull -t ${IMAGE_URL} .
