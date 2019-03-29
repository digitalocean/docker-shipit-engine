FROM ruby:2.6.2-slim

COPY entrypoint.sh /usr/local/bin/

ENV RAILS_VERSION 5.2.3
ENV SHIPIT_VERSION 0.27.1
ENV CI true
# throw errors if Gemfile has been modified since Gemfile.lock
RUN apt-get update && apt-get install -y \
    curl build-essential libssl-dev libpq-dev git libsqlite3-dev default-libmysqlclient-dev \
    && gem install rails -v "${RAILS_VERSION}" \
    && curl -fSL https://github.com/Shopify/shipit-engine/archive/v"${SHIPIT_VERSION}".tar.gz -o shipit.tar.gz \
    && mkdir -p /usr/src \
    && tar -zxC /usr/src -f shipit.tar.gz \
    && cd /usr/src/shipit-engine-"${SHIPIT_VERSION}" \
    && bundle install

RUN rm -rf ./shipit.tar.gz

# nvm environment variables
ENV NVM_DIR /usr/local/nvm
ENV NODE_VERSION 8.2.1

# install nvm
# https://github.com/creationix/nvm#install-script
RUN curl --silent -o- https://raw.githubusercontent.com/creationix/nvm/v0.31.2/install.sh | bash

# install node and npm
RUN . $NVM_DIR/nvm.sh \
    && nvm install $NODE_VERSION \
    && nvm alias default $NODE_VERSION \
    && nvm use default

# add node and npm to path so the commands are available
ENV NODE_PATH $NVM_DIR/v$NODE_VERSION/lib/node_modules
ENV PATH $NVM_DIR/versions/node/v$NODE_VERSION/bin:$PATH

# confirm installation
RUN node -v
RUN npm -v

EXPOSE 3000

ENTRYPOINT ["entrypoint.sh"]

RUN ls ./usr/src/shipit-engine-"${SHIPIT_VERSION}"/config/
CMD ./usr/src/shipit-engine-"${SHIPIT_VERSION}"/bin/rails server -b 0.0.0.0 -e production
