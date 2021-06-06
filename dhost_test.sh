#!/bin/sh

function err {
	printf "dhost_test: %s\n" "$1" >&2
	exit 1
}

if [ -z "$1" ]; then
	err "host was not provided"
else
	TARGET_HOST="$1"
fi

if [ -z "$DHOST_WEBHOOK_ID" ]; then
	err "discord webhook id was not provided"
fi

if [ -z "$DHOST_WEBHOOK_TOKEN" ]; then
	err "discord webhook token was not provided"
fi

DATA_DIR="data"

if [ ! -d "$DATA_DIR" ]; then
	err "data directory: no such directory"
fi

ON_DOWN="$(cat $DATA_DIR/on_down.json)"
ON_UP="$(cat $DATA_DIR/on_up.json)"

WEBHOOK_URL="https://discord.com/api/webhooks/$DHOST_WEBHOOK_ID/$DHOST_WEBHOOK_TOKEN"

if [ -z "$DHOST_COOLDOWN" ]; then
	DHOST_COOLDOWN=30
fi


if [ -z "$DHOST_CURL_TIMEOUT" ]; then
	DHOST_CURL_TIMEOUT=15
fi

function send_message {
	curl -X POST -H "Content-Type: application/json" --data "$1" $WEBHOOK_URL
}

is_host_down=true

while true; do
	if ! curl --silent --max-time $DHOST_CURL_TIMEOUT $TARGET_HOST >/dev/null; then

		if ! $is_host_down; then
			printf "dhost_test: timeout of %s seconds has been reached. Host is down\n" "$DHOST_CURL_TIMEOUT"
			is_host_down=true
			send_message "$ON_DOWN"
		fi

	else

		if $is_host_down; then
			printf "dhost_test: Host is up\n" "$DHOST_CURL_TIMEOUT"
			is_host_down=false
			send_message "$ON_UP"
		fi
	fi

	sleep $DHOST_COOLDOWN
done
