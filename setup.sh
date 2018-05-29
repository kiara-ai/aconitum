#!/bin/bash

clear

. .env

app=$(printf "%s_%s" $DOCKER_NETWORK $DOCKER_APP)

# composer automatically start php without xdebug, so we will disable the
# warning, that said xdebug is enabled!
#
# https://getcomposer.org/doc/articles/troubleshooting.md#xdebug-impact-on-composer \

docker run \
    --rm \
    --net $DOCKER_NETWORK --ip $DOCKER_APP_IP \
    -v `pwd`:/usr/app \
    -w /usr/app \
    -e COMPOSER_DISABLE_XDEBUG_WARN=1 \
    --name $app \
    $app \
    composer require --no-progress --profile --prefer-dist --prefer-source \
            guzzlehttp/guzzle \
            illuminate/config \
            illuminate/container \
            illuminate/support \
            phpunit/phpunit \
            symfony/css-selector \
            symfony/dom-crawler \
            vlucas/phpdotenv
