#!/usr/bin/env bash
#ddev-generated

CONTAINER_ID=$(docker ps -aqf "name=ddev-router")

printf " Adding Insight Config to Traefik "

TEMPLATE=$(cat "$DDEV_APPROOT/.ddev/redis-insight/redis-insight.yaml")
TEMPLATE="${TEMPLATE//DDEV_TLD/$DDEV_TLD}"
docker exec "$CONTAINER_ID" bash -c "echo '$TEMPLATE' > /mnt/ddev-global-cache/traefik/config/redis-insight.yaml"

printf " Done\n"