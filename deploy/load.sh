#!/bin/sh

wget https://raw.githubusercontent.com/evilbc/biznes-elektroniczny/main/deploy/docker-compose.yaml

docker stack deploy -c docker-compose.yaml BE_184276 --with-registry-auth
