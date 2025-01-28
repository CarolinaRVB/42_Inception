DOCKER_COMPOSE_PATH = ./srcs/docker-compose.yml
ENV = srcs/.env

DOMAIN_NAME = crebelo-.42.fr
DB_NAME = maria.db
DB_USER = user
DB_ROOT_USER = crebelo-

create_dirs:
	@mkdir -p /home/crebelo-/data/mariadb

create_env:
	@echo "DB_NAME=$(DB_NAME)" > $(ENV)
	@echo "DB_USER=$(DB_USER)" >> $(ENV)
	@echo "DB_ROOT_USER=$(DB_ROOT_USER)" >> $(ENV)
	@echo "DOMAIN_NAME=$(DOMAIN_NAME)" >> $(ENV) 

create_secrets:
	mkdir -p srcs/secrets
	[ -f srcs/secrets/db_root_password ] || openssl rand -base64 16 > srcs/secrets/db_root_password
	[ -f srcs/secrets/db_password ] || openssl rand -base64 16 > srcs/secrets/db_password
	chmod 

up:
	docker compose -f $(DOCKER_COMPOSE_PATH) up -d

down:
	docker compose -f $(DOCKER_COMPOSE_PATH) down
	rm -f srcs/.env

build:
	$(MAKE) create_dirs
	$(MAKE) create_secrets
	$(MAKE) create_env
	docker compose -f $(DOCKER_COMPOSE_PATH) build