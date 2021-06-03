#!/bin/sh

if [ -z "$1" ]; then
	printf "dhost_test: host was not provided\n" >&2
	exit 1
else
	TARGET_HOST="$1"
fi

if [ -z "$DHOST_WEBHOOK_ID" ]; then
	printf "dhost_test: discord webhook id was not provided\n" >&2
	exit 1
fi

if [ -z "$DHOST_WEBHOOK_TOKEN" ]; then
	printf "dhost_test: discord webhook token was not provided\n" >&2
	exit 1
fi

WEBHOOK_URL="https://discord.com/api/webhooks/$DHOST_WEBHOOK_ID/$DHOST_WEBHOOK_TOKEN"

if [ -z "$DHOST_COOLDOWN" ]; then
	DHOST_COOLDOWN=30
fi

if [ -z "$DHOST_CURL_TIMEOUT" ]; then
	DHOST_CURL_TIMEOUT=15
fi

function send_message {
	curl -X POST -F "content=$1" $WEBHOOK_URL
}

is_host_down=false

while true; do
	if ! curl --silent --max-time $DHOST_CURL_TIMEOUT $TARGET_HOST >/dev/null; then
		printf "dhost_test: timeout of %s seconds has been reached\n" "$DHOST_CURL_TIMEOUT" >&2

		if ! $is_host_down; then
			is_host_down=true
			send_message "The host ${TARGET_HOST} has gone offline"
		fi

	else

		if $is_host_down; then
			is_host_down=false
			send_message "The host ${TARGET_HOST} has come back online"
		fi
	fi

	sleep $DHOST_COOLDOWN
done
