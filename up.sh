#!/bin/bash

set -xe

clear

# ---------------------------------------------------- Check configuration --
if [ ! -f .env ]; then
    cp .env.example .env
    echo "Please fill in .env file first"
    exit
fi

. .env

# --------------------------------------------- Initialize local variables --
mysql=$(printf "%s_%s" $DOCKER_NETWORK $DOCKER_MYSQL)
redis=$(printf "%s_%s" $DOCKER_NETWORK $DOCKER_REDIS)

# --------------------------------------------------------- Create network --
if ! docker network ls | grep -q $DOCKER_NETWORK; then
    docker network create --subnet=${DOCKER_NETWORK_IP}/16 $DOCKER_NETWORK
fi

# ------------------------------------------------------------ Start mysql --
if ! docker ps | grep -q "$mysql"; then
    docker run \
        -d \
        --name $mysql \
        --restart unless-stopped \
        --mount source=$mysql,target=/var/lib/mysql \
        --net $DOCKER_NETWORK --ip $DOCKER_MYSQL_IP \
        -e MYSQL_ROOT_PASSWORD=$MYSQL_PASSWORD \
        -e MYSQL_DATABASE=$MYSQL_DATABASE \
        mysql:5.7
fi

# ----------------------------------------------- Start redis (persistent) --
if ! docker ps | grep -q "$redis"; then
    docker run \
        -d \
        --restart unless-stopped \
        --name $redis \
        --mount source=$redis,target=/data \
        --net $DOCKER_NETWORK --ip $DOCKER_REDIS_IP \
        redis:alpine \
        redis-server \
        --appendonly yes
fi
