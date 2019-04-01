#!/bin/sh

set -e

export RAILS_ENV
RAILS_ENV="${RAILS_ENV:="production"}"
export RAILS_SERVE_STATIC_FILES
RAILS_SERVE_STATIC_FILES="${RAILS_SERVE_STATIC_FILES:="enabled"}"

export GITHUB_DOMAIN
GITHUB_DOMAIN="${GITHUB_DOMAIN:="github.com"}"
export GITHUB_BOT_LOGIN
GITHUB_BOT_LOGIN="${GITHUB_BOT_LOGIN:=""}"
export GITHUB_OAUTH_TEAM
GITHUB_OAUTH_TEAM="${GITHUB_OAUTH_TEAM:=""}"
export REDIS_URL
REDIS_URL="${REDIS_URL:="redis://localhost"}"

if [ -z "${SECRET_KEY_BASE}" ]; then
    echo "SECRET_KEY_BASE variable not defined."
    exit 1
fi

if [ -z "${SHIPIT_HOST}" ]; then
    echo "SHIPIT_HOST variable not defined."
    exit 1
fi

if [ -z "${GITHUB_APP_ID}" ]; then
    echo "GITHUB_APP_ID variable not defined."
    exit 1
fi

if [ -z "${GITHUB_INSTALLATION_ID}" ]; then
    echo "GITHUB_INSTALLATION_ID variable not defined."
    exit 1
fi

if [ -z "${GITHUB_WEBHOOK_SECRET}" ]; then
    echo "GITHUB_WEBHOOK_SECRET variable not defined."
    exit 1
fi

if [ -z "${GITHUB_PRIVATE_KEY}" ]; then
    echo "GITHUB_PRIVATE_KEY variable not defined."
    exit 1
fi

if [ -z "${GITHUB_OAUTH_ID}" ]; then
    echo "GITHUB_OAUTH_ID variable not defined."
    exit 1
fi

if [ -z "${GITHUB_OAUTH_SECRET}" ]; then
    echo "GITHUB_OAUTH_SECRET variable not defined."
    exit 1
fi

exec "$@"
