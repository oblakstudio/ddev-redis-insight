#!/usr/bin/env bash
#ddev-generated

# Insight base dir
INSIGHT_DIR="$HOME/.ddev/redis-insight"

# Insight activity file
INSIGHT_CHECK_FILE="$INSIGHT_DIR/$DDEV_PROJECT"

# If the activity file exists, remove it
if [ -f "$INSIGHT_CHECK_FILE" ]; then
    rm -f "$INSIGHT_CHECK_FILE" > /dev/null 2>&1
fi;


if [ -n "$(ls -A "$INSIGHT_DIR")" ]; then
	echo -e " \e[33mddev-redis-insight is running. If you want to stop it run 'ddev ri stop'.\e[0m"
    exit 0;
fi;

CONTAINER_ID=$(docker ps -q -f name="ddev-redis-insight")

if [ -n "$CONTAINER_ID" ]; then
    printf " Container ddev-redis-insight "
    docker container stop "$CONTAINER_ID" > /dev/null
    printf " Stopped\n"
fi;

printf " Container ddev-redis-insight "
docker container rm "$CONTAINER_ID" > /dev/null
printf " Removed\n"
