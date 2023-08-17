#!/usr/bin/env bash
#ddev-generated

D=${0%/*}
[ "$D" = x"$0" ] && D=.   # portable variant, use [[ ...]] in bash freely
readonly D                 # optional, for additional safety

# shellcheck source="scripts/common.bash"
source "$D/common.bash"

printf " Adding Database to Redis insight "

INSIGHT_URL="https://redis-insight.${DDEV_TLD}/api/databases"
INSIGHT_CHECK_FILE="$HOME/.ddev/redis-insight/$DDEV_PROJECT"

RESPONSE=$(curl -s "$INSIGHT_URL" 2> /dev/null)

if grep -qi "$DDEV_PROJECT" <<< "$RESPONSE"; then
    printf " Already exists\n"
    exit 0
fi

TEMPLATE=$(cat <<EOF
{
    "name": "$DDEV_PROJECT",
    "host": "ddev-$DDEV_PROJECT-redis",
    "port": 6379,
    "username": "redis",
    "password": "redis"
}
EOF
)

RESPONSE_CODE=$(perform_action_with_retry 5 create_database "$TEMPLATE" "$INSIGHT_URL")

if [ "$RESPONSE_CODE" -eq 201 ]; then
    printf " Done\n"
    touch "$INSIGHT_CHECK_FILE"
    exit 0
fi

printf " Failed\n"
exit 1
