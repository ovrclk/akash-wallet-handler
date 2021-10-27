#!/bin/bash
echo "Your private key is :"
docker exec -it akash /bin/bash -c "akash keys export default"
echo "Your mnemonic recovery phrase is :"
docker exec -it akash /bin/bash -c "akash keys mnemonic"
