#!/usr/bin/env bash
#ddev-generated

CONTAINER_ID=$(docker ps -aqf "name=ddev-router")

TEMPLATE=$(cat "$DDEV_APPROOT/.ddev/redis-insight/redis-insight.yaml")
TEMPLATE="${TEMPLATE//DDEV_TLD/$DDEV_TLD}"
#TEMPLATE="${TEMPLATE//PROJECT_URL/$PROJECT_URL}"
docker exec "$CONTAINER_ID" bash -c "echo '$TEMPLATE' > /mnt/ddev-global-cache/traefik/config/redis-insight.yaml"