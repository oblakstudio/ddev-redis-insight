#!/usr/bin/env bash
#ddev-generated

D=${0%/*}
[ "$D" = x"$0" ] && D=.
readonly D

# shellcheck source="scripts/common.bash"
source "$D/common.bash"

DDEV_TLD=ddev.site
INSIGHT_CHECK_FILE="$HOME/.ddev/.redis-insight-configured"

if [ -f "$INSIGHT_CHECK_FILE" ]; then
    exit 0
fi;

printf " Configuring Redis Insight "

INSIGHT_URL="https://redis-insight.${DDEV_TLD}/api/settings"
TEMPLATE=$(cat <<EOF
{
  "theme": null,
  "scanThreshold": 10000,
  "batchSize": 5,
  "agreements": {
    "version": "1.0.0",
    "eula": true,
    "analytics": false,
    "encryption": true,
    "notifications": false
  }
}
EOF
)

RESPONSE_CODE=$(perform_action_with_retry 10 create_config "$TEMPLATE" "$INSIGHT_URL")

if [ "$RESPONSE_CODE" -eq 200 ]; then
    printf " Done\n"
    touch "$INSIGHT_CHECK_FILE"
    exit 0
fi


printf " Failed\n"
exit 1
