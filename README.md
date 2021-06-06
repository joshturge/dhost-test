
# Discord Host Test

This script will send HTTP requests to a given host continuously with a cool down.
If the host doesn't respond in a reasonable amount of time or if an error occurs, 
the script will send a discord message informing users the host is offline.
Once the host comes back online, another discord will be sent informing the host is back online.

This script is POSIX compliant.

## Usage

### Setup Embeds

First create a data directory in the root of this project, this is where the script will read
json files from. The script will only look for two files, the 
[on_down.json](example/on_down.json) and [on_up.json](example/on_up.json)
files. These files contain a raw json message that are sent when the selected host goes offline/online.
These json files can contain anything as long as it obeys Discord's
[Execute Webhook Endpoint](https://discord.com/developers/docs/resources/webhook#execute-webhook).
Examples are provided [here](example/).

### The Command

Basic usage of the command, you must provide a host, webhook ID and token otherwise
the script will fail to run.

```bash
$ export DHOST_WEBHOOK_ID="235325245324555"
$ export DHOST_WEBHOOK_TOKEN="kjhewkfwkfwef"
$ dhost_test https://joshturge.dev/
```

## Environment Variables

| Variable 						| Default Value |
|---------------------|---------------|
| DHOST_WEBHOOK_ID 		| None 					|
| DHOST_WEBHOOK_TOKEN | None 					|
| DHOST_COOLDOWN 			| 30 						|
| DHOST_CURL_TIMEOUT 	| 15 						|

## License

This project is licensed under the BSD License - see the [LICENSE](LICENSE)
file for details.
