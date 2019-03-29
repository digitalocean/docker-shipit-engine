FROM ruby:2.6.2-alpine3.9

ENV RAILS_VERSION 5.2.3
ENV SHIPIT_VERSION 0.27.1

# throw errors if Gemfile has been modified since Gemfile.lock
RUN bundle config --global frozen 1

RUN apk add --no-cache --virtual .build-deps \
        build-base \
        curl \
        git \
    && gem install rails -v "${RAILS_VERSION}" \
    && curl -fSL https://github.com/Shopify/shipit-engine/archive/v"${SHIPIT_VERSION}".tar.gz -o shipit.tar.gz \
    && mkdir -p /usr/src \
    && tar -zxC /usr/src -f shipit.tar.gz \
    && rails new shipit --skip-action-cable --skip-turbolinks --skip-action-mailer --skip-active-storage -m /usr/src/shipit-engine-"${SHIPIT_VERSION}"/template.rb \
    && rm -rf shipit.tar.gz \
    && ls -la \
    && apk del .build-deps

EXPOSE 3000

ENTRYPOINT ["entrypoint.sh"]
CMD ["shipit/bin/rails", "server", "-b", "0.0.0.0" -e "production"]
