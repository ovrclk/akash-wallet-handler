#!/bin/bash
echo "Setting up certificate"
docker exec -it akash /bin/bash -c 'akash tx cert create client --chain-id $AKASH_CHAIN_ID --keyring-backend $AKASH_KEYRING_BACKEND --from $AKASH_KEY_NAME --node $AKASH_NODE --fees 5000uakt'
