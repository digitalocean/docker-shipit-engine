#!/bin/sh

set -e

if [ -z "${DATABASE_URL}" ]; then
    echo "DATABASE_URL variable not defined."
    exit 1
fi

if [ -z "${REDIS_URL}" ]; then
    echo "REDIS_URL variable not defined."
    exit 1
fi

if [ -z "${SECRET_KEY_BASE}" ]; then
    echo "SECRET_KEY_BASE variable not defined."
    exit 1
fi

command=$1

case $command in
  setup)
    bundle exec rake railties:install:migrations db:create db:migrate
    exit 0
    ;;
  upgrade)
    bundle exec rake railties:install:migrations db:migrate
    exit 0
    ;;
esac

exec "$@"
