FROM ruby:2.6.2-slim

COPY entrypoint.sh /usr/local/bin/

ENV RAILS_VERSION 5.2.3
ENV SHIPIT_VERSION 0.27.1

# nvm environment variables
ENV NVM_DIR /usr/local/nvm
ENV NODE_VERSION 8.2.1
ENV NODE_PATH $NVM_DIR/v$NODE_VERSION/lib/node_modules
ENV PATH $NVM_DIR/versions/node/v$NODE_VERSION/bin:$PATH

# throw errors if Gemfile has been modified since Gemfile.lock
RUN apt-get update && apt-get install -y --no-install-recommends --no-install-suggests \
        build-essential \
        curl \
        default-libmysqlclient-dev \
        git \
        libpq-dev \
        libsqlite3-dev \
        sqlite3 \
        sqlite3-doc \
        libssl-dev \
    && gem install rails -v "${RAILS_VERSION}" \
    && rails new shipit --skip-action-cable --skip-turbolinks --skip-action-mailer --skip-active-storage -m https://raw.githubusercontent.com/Shopify/shipit-engine/v"${SHIPIT_VERSION}"/template.rb \
    && curl --silent -o- https://raw.githubusercontent.com/creationix/nvm/v0.31.2/install.sh | bash \
    && . $NVM_DIR/nvm.sh \
    && nvm install $NODE_VERSION \
    && nvm alias default $NODE_VERSION \
    && nvm use default \
    && apt-get remove --purge --auto-remove -y build-essential curl default-libmysqlclient-dev libpq-dev libsqlite3-dev libssl-dev \
    && apt-get autoremove -y

EXPOSE 3000

ENTRYPOINT ["entrypoint.sh"]

WORKDIR /shipit

CMD bin/rails server -b 0.0.0.0
