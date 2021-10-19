#!/bin/bash
echo "What moniker (name) would you like to use"
read moniker
echo "AKASH_MONIKER=$moniker" >> variables
docker kill akash ; docker run -itd --env-file=variables --rm --name akash -v $(pwd)/data:/root/.akash akash
docker exec -it akash /bin/bash -c 'akash init --chain-id $AKASH_CHAIN_ID $AKASH_MONIKER'
