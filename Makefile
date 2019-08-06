.PHONY: help
.DEFAULT_GOAL := help

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

docker-compose-up: ## launch airflow environment
	docker-compose up -d

docker-compose-kill: ## stop containers
	docker-compose kill

docker-compose-remove: ## remove containers
	docker-compose rm -f

docker-compose-logs-follow: ## docker compose show logs
	docker-compose logs -f

docker-compose-exec-scheduler: ## exec in scheduler container
	docker-compose exec scheduler /bin/bash

create-env: ## create env
	pipenv --python ~/.pyenv/versions/3.6.9/bin/python

install-deps: ## install dependencies
	pipenv install
