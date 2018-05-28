#!/bin/bash

if [ -f .env ]; then
    . .env
    docker rm -f `docker ps | grep ${DOCKER_NETWORK}_ | cut -d' ' -f1`
fi
