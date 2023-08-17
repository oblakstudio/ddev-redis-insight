#!/bin/bash
# ##ddev-generated

#;
# create_database()
## Creates a database in Redis Insight
# @param TEMPLATE: The template to be used
# @param INSIGHT_URL: The url to Redis Insight
# @return The response code
#"
create_database() {
    local TEMPLATE=$1
    local INSIGHT_URL=$2

    curl -s -o /dev/null -w "%{http_code}" -H 'Content-Type: application/json' -X POST -d "$TEMPLATE" "$INSIGHT_URL"
}

#;
# create_config()
## Creates a config in Redis Insight
# @param TEMPLATE: The template to be used
# @param INSIGHT_URL: The url to Redis Insight
# @return The response code
#"
create_config() {
    local TEMPLATE=$1
    local INSIGHT_URL=$2

	curl -s -o /dev/null -w "%{http_code}" -H 'Content-Type: application/json' -X PATCH -d "$TEMPLATE" "$INSIGHT_URL"
}

#;
# perform_action_with_retry()
## Performs an api action to Redis Insight with a retry mechanism
#
# @param MAX_RETRIES The maximum number of retries
# @param ACCTION_FUNCTION: The function to be executed
# @param TEMPLATE: The template to be used
# @param INSIGHT_URL: The url to Redis Insight
# @return The response code
#"
perform_action_with_retry() {
    local MAX_RETRIES="$1"
    local ACTION_FUNCTION="$2"
    local TEMPLATE="$3"
    local INSIGHT_URL="$4"

    local COUNT=0
    local RESPONSE_CODE=0

    while [ "$COUNT" -lt "$MAX_RETRIES" ]; do
        RESPONSE_CODE=$($ACTION_FUNCTION "$TEMPLATE" "$INSIGHT_URL")
		RESPONSE_CODE=$((RESPONSE_CODE))
		if ! [[ "$RESPONSE_CODE" =~ ^[0-9]+$ ]]; then
    		RESPONSE_CODE=0
		fi

		if [ "$RESPONSE_CODE" -ne 200 ] && [ "$RESPONSE_CODE" -ne 201 ]; then
            printf "." >&2 # Print a dot to stderr so the user knows something is happening
            sleep 1
            ((COUNT++))
        else
            break
        fi
    done

    echo "$RESPONSE_CODE"
}
