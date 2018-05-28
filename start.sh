#!/bin/bash

clear

. .env

app=$(printf "%s_%s" $DOCKER_NETWORK $DOCKER_APP)

# ------------------------------------------------------ Build application --
if ! docker images | grep -q $app; then
    docker build -t $app -f Dockerfile.dev .
fi

# ------------------------------------------------------ Start application --
if ! docker ps | grep -q $app; then
    docker run \
        --rm \
        --net $DOCKER_NETWORK --ip $DOCKER_APP_IP \
        -v `pwd`:/usr/app \
        -w /usr/app \
        --name $app\
        $app \
        php app.php
fi
