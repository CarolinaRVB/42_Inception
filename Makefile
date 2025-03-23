DOCKER_COMPOSE_PATH = ./srcs/docker-compose.yml
ENV = srcs/.env
DOMAIN_NAME = crebelo.42.fr
DB_NAME = maria_db
DB_USER = user
DB_ROOT_USER = crebelo
DB_HOST=mariadb
WEBSITE_WP = crebelo
ADMIN_EMAIL = crebelo@example.com
USER_EMAIL = user@example.com


create_dirs:
	@mkdir -p /home/crebelo-/data/mariadb
	@mkdir -p /home/crebelo-/data/wordpress

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
	@openssl rand -base64 32 | tr -d '/+' | tr -d '\n' > db_password.txt
	@openssl rand -base64 32 | tr -d '/+' | tr -d '\n' > db_root_password.txt
	@chmod 600 db_password.txt db_root_password.txt


escape_special_chars = $(shell echo $(1) | sed 's/[&/\]/\\&/g; s/[ ]/\\ /g; s/"/\\"/g; s/'\''/\\'\''/g')

fill_init_sql:
	@cp srcs/requirements/mariadb/tools/init.sql.template srcs/requirements/mariadb/tools/init.sql
	@chmod 755 srcs/requirements/mariadb/tools/init.sql
	@sed -i "s/{{DB_NAME}}/$(DB_NAME)/g" srcs/requirements/mariadb/tools/init.sql
	@sed -i "s/{{DB_USER}}/$(DB_USER)/g" srcs/requirements/mariadb/tools/init.sql
	@sed -i "s/{{DB_ROOT_USER}}/$(DB_ROOT_USER)/g" srcs/requirements/mariadb/tools/init.sql
	@sed -i "s/{{DB_PASSWORD}}/$(call escape_special_chars,$(shell cat db_password.txt))/g" srcs/requirements/mariadb/tools/init.sql
	@sed -i "s/{{DB_ROOT_PASSWORD}}/$(call escape_special_chars,$(shell cat db_root_password.txt))/g" srcs/requirements/mariadb/tools/init.sql


up:
	docker compose -f $(DOCKER_COMPOSE_PATH) up

down:
	docker compose -f $(DOCKER_COMPOSE_PATH) down --volumes --remove-orphans
	docker image prune -a -f  # Removes all unused images
	docker system prune -f --volumes  # Removes unused data, including networks and volumes
	rm -f srcs/.env
	rm -f srcs/requirements/mariadb/tools/init.sql
	rm -rf /home/crebelo-/data/mariadb
	rm -rf /home/crebelo-/data/wordpress

build:
	$(MAKE) create_dirs
	$(MAKE) create_env
	$(MAKE) fill_init_sql
	docker compose -f $(DOCKER_COMPOSE_PATH) build --no-cache

# $(MAKE) create_secrets
# rm -f db_root_password.txt
# rm -f db_password.txt