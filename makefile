# Default profile
PROFILE ?= stable

TOOLS_COMPOSE = docker/docker-compose.tools.yml
DB_COMPOSE = docker/docker-compose.databases.yml

.PHONY: help up down restart logs ps bootstrap reset health

help:
	@echo ""
	@echo "Secure Chain Stack Commands"
	@echo "============================="
	@echo ""
	@echo "Profiles (set PROFILE=stable|latest, default is stable):"
	@echo "  PROFILE=stable make up    Start stack with stable versions"
	@echo "  PROFILE=latest make up    Start stack with latest versions"
	@echo ""
	@echo "Targets:"
	@echo "  make network-create"
	@echo "      Create the Docker network 'securechain' if it doesn't exist."
	@echo ""
	@echo "  make up MODE=all|tools|databases"
	@echo "     Start services based on MODE:"
	@echo "         MODE=all        - Start databases and tools"
	@echo "         MODE=databases  - Start only Neo4j and MongoDB"
	@echo "         MODE=tools      - Start only SecureChain tools"
	@echo ""
	@echo "  make down"
	@echo "      Stop all services (tools + databases)."
	@echo ""
	@echo "  make generate-env"
	@echo "      Generate .env and .env.local from the selected profile template."
	@echo ""
	@echo "  make download-dump"
	@echo "      Download databases dump from Zenodo."
	@echo ""
	@echo "  make logs"
	@echo "      Show logs of all running containers."
	@echo ""
	@echo "  make ps"
	@echo "      Show running containers."
	@echo ""
	@echo "Usage examples:"
	@echo "  make generate-env PROFILE=latest"
	@echo "  make download-dump"
	@echo "  make up MODE=databases PROFILE=stable"
	@echo ""

network-create:
	@if ! docker network inspect securechain >/dev/null 2>&1; then \
		echo "Creating securechain network..."; \
		docker network create securechain; \
	else \
		echo "Securechain network already exists, nothing to do"; \
	fi

generate-env:
	bash scripts/generate_env.sh

download-dump:
	bash scripts/download_dump.sh

up:
	$(MAKE) network-create
	$(MAKE) generate-env
ifeq ($(MODE),tools)
	docker compose -f $(TOOLS_COMPOSE) up -d
else ifeq ($(MODE),databases)
	docker compose -f $(DB_COMPOSE) up -d
else ifeq ($(MODE),all)
	docker compose -f $(DB_COMPOSE) up -d
	docker compose -f $(TOOLS_COMPOSE) up -d
else
	@echo "Invalid MODE specified. Use MODE=all, MODE=tools, or MODE=databases."
endif

down:
	docker compose -f $(TOOLS_COMPOSE) down
	docker compose -f $(DB_COMPOSE) down

restart:
	$(MAKE) down
	$(MAKE) up
