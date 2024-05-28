# Makefile for Rails project

# Variables
DOCKER_COMPOSE = docker-compose
DOCKER_EXEC = $(DOCKER_COMPOSE) exec backend
RAILS = $(DOCKER_EXEC) bundle exec rails
BUNDLE = $(DOCKER_EXEC) bundle
YARN = $(DOCKER_EXEC) yarn

# Targets
.PHONY: setup start stop restart console test swagger reset

setup:
	$(DOCKER_COMPOSE) build
	$(DOCKER_COMPOSE) run --rm backend bin/setup

reset:
	$(DOCKER_EXEC) rake db:reset

bash:
	$(DOCKER_EXEC) bash

start:
	$(DOCKER_COMPOSE) up

stop:
	$(DOCKER_COMPOSE) down

restart: stop start

inventory_sale:
	$(RAILS) inventory:start

console:
	$(RAILS) console

test:
	$(BUNDLE) exec rspec spec/controllers spec/models

swagger:
	$(RAILS) rswag:specs:swaggerize

# Custom commands
install:
	$(BUNDLE) install
	$(YARN) install --check-files

migrate:
	$(RAILS) db:migrate

rollback:
	$(RAILS) db:rollback
