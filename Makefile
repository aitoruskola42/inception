# Variable names
COMPOSE_FILE = srcs/docker-compose.yml
ENV_FILE = srcs/.env

# Colors for output
GREEN = \033[0;32m
NC = \033[0m

# Main rule
all: up

# Build and start the containers
up:
	@echo "$(GREEN)Creating directories for volumes if they don't exist...$(NC)"
	mkdir -p ./data ./data/wordpress ./data/mariadb ./data/bonus ./data/bonus/ftp ./data/bonus/adminer ./data/nginx
	@echo "$(GREEN)Starting the containers...$(NC)"
	@docker-compose -f $(COMPOSE_FILE) --env-file $(ENV_FILE) up -d --build

# Stop and remove the containers
down:
	@echo "$(GREEN)Stopping the containers...$(NC)"
	@docker-compose -f $(COMPOSE_FILE) down

# Restart the containers
restart: down up

# Show the logs of the containers
logs:
	@docker-compose -f $(COMPOSE_FILE) logs

# Clean all Docker resources (use with caution!)
clean: down
	@echo "$(GREEN)Cleaning all Docker resources...$(NC)"
	@docker system prune -a --volumes -f
	@docker network prune -f

# Rule to rebuild a specific service
rebuild:
	@echo "$(GREEN)Rebuilding the service $(SERVICE)...$(NC)"
	@docker-compose -f $(COMPOSE_FILE) build --no-chache $(SERVICE)
	@docker-compose -f $(COMPOSE_FILE) up -d --no-deps $(SERVICE)

clean-network:
	@echo "$(GREEN)Cleaning the network...$(NC)"
	@if [ -f $(COMPOSE_FILE) ]; then \
		docker-compose -f $(COMPOSE_FILE) down --remove-orphans; \
	else \
		echo "$(RED)docker-compose.yml file not found in $(COMPOSE_FILE)$(NC)"; \
	fi
	@docker network prune -f

# Show the status of the containers
status:
	@docker-compose -f $(COMPOSE_FILE) ps

.PHONY: all up down restart logs clean rebuild status clean-network