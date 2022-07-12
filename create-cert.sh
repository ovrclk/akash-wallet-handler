#!/bin/bash
echo "Setting up certificate"
. variables
#Generate Cert
docker exec -it akash /bin/bash -c 'akash tx cert generate client --chain-id $AKASH_CHAIN_ID --keyring-backend $AKASH_KEYRING_BACKEND --from $AKASH_KEY_NAME --node $AKASH_NODE --fees 5000uakt'
#Publish Cert
docker exec -it akash /bin/bash -c 'akash tx cert publish client --chain-id $AKASH_CHAIN_ID --keyring-backend $AKASH_KEYRING_BACKEND --from $AKASH_KEY_NAME --node $AKASH_NODE --fees 5000uakt'
