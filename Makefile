DOCKER_COMPOSE_PATH = ./srcs/docker-compose.yml
ENV = srcs/.env
DOMAIN_NAME = www.crebelo-.42.fr
DB_NAME = maria_db
DB_USER = user
DB_ROOT_USER = crebelo-
DB_HOST=mariadb
WEBSITE_WP = https://crebelo-.42.fr
ADMIN_EMAIL = crebelo@example.com
USER_EMAIL = user@example.com


create_dirs:
	@mkdir -p $(HOME)/data/mariadb
	@mkdir -p $(HOME)/data/wordpress
	@mkdir -p secrets

create_env:
	@echo "DB_NAME=$(DB_NAME)" > $(ENV)
	@echo "DB_HOST=$(DB_HOST)" >> $(ENV)
	@echo "DB_USER=$(DB_USER)" >> $(ENV)
	@echo "DB_ROOT_USER=$(DB_ROOT_USER)" >> $(ENV)
	@echo "DOMAIN_NAME=$(DOMAIN_NAME)" >> $(ENV) 
	@echo "WEBSITE_WP=$(WEBSITE_WP)" >> $(ENV)
	@echo "ADMIN_EMAIL=$(ADMIN_EMAIL)" >> $(ENV)
	@echo "USER_EMAIL=$(USER_EMAIL)" >> $(ENV)

create_secrets:
	@openssl rand -base64 48 | tr -dc 'A-Za-z0-9' | head -c 32 > secrets/db_password.txt
	@openssl rand -base64 48 | tr -dc 'A-Za-z0-9' | head -c 32 > secrets/db_root_password.txt


stop:
	docker compose -f $(DOCKER_COMPOSE_PATH) stop

start:
	docker compose -f $(DOCKER_COMPOSE_PATH) start

up:
	docker compose -f $(DOCKER_COMPOSE_PATH) up -d


down:
	docker compose -f $(DOCKER_COMPOSE_PATH) down --rmi all -v
	docker image prune -a -f  # Removes all unused images
	docker system prune -f --volumes  # Removes unused data, including networks and volumes
	rm -f srcs/.env
	rm -f secrets/*
	sudo rm -rf $(HOME)/data

build:
	$(MAKE) create_dirs
	$(MAKE) create_env
	$(MAKE) create_secrets
	docker compose -f $(DOCKER_COMPOSE_PATH) build --no-cache