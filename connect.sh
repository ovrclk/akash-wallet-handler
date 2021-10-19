#!/bin/bash
rm variables
AKASH_NET="https://raw.githubusercontent.com/ovrclk/net/master/mainnet"
AKASH_VERSION="$(curl -s "https://raw.githubusercontent.com/ovrclk/net/master/mainnet/version.txt")"
AKASH_KEYRING_BACKEND=os
AKASH_CHAIN_ID="$(curl -s "https://raw.githubusercontent.com/ovrclk/net/master/mainnet/chain-id.txt")"
AKASH_NODE="$(curl -s "https://raw.githubusercontent.com/ovrclk/net/master/mainnet/rpc-nodes.txt" | head -1)"
AKASH_KEY_NAME="default"

echo "AKASH_NODE=$AKASH_NODE" > variables
echo "AKASH_CHAIN_ID=$AKASH_CHAIN_ID" >> variables
echo "AKASH_KEYRING_BACKEND=$AKASH_KEYRING_BACKEND" >> variables
echo "AKASH_VERSION=$AKASH_VERSION" >> variables
echo "AKASH_NET=$AKASH_NET" >> variables
echo "AKASH_KEY_NAME=$AKASH_KEY_NAME" >> variables
