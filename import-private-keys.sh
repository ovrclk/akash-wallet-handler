#!/bin/bash
docker cp key.file akash:/key.file
docker exec -it akash /bin/bash -c "akash keys import mello /key.file"
docker exec -it akash /bin/bash -c "rm /key.file"
