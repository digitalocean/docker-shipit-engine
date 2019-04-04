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

exec "$@"
