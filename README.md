# akash-wallet-handler

A command line GUI for managing an Akash wallet

## Dependencies

- Docker
- JQ
- Dialog

Tested on Ubuntu 18.04+ 
```
apt-get update ; apt-get -yqq install jq dialog docker.io
```

Mac users please install `dialog` and `jq` with "brew"

## Getting Started

The akash-wallet-handler will detect a first time run and create a data folder and variables file in the location where `./menu.sh` is run.  The data folder and variables file will contain your wallet information and should not be deleted or modified.  Be sure to backup these files!

```
#To start akash-wallet-handler run:
./menu.sh
```
## Support

If you need help or want to request changes please contact the team in Discord or create an issue here on github.

## Todos
```
-- Deployment manager
-- View last tx
-- View bids
-- Place bids
-- Bid manager?
```
